# frozen_string_literal: true

RSpec.describe Auth::Sanitizer::FilteredAttributes do
  subject(:instance) { poro_class.new("super-secret", "bolt") }

  let(:poro_class) do
    Class.new do
      include Auth::Sanitizer::FilteredAttributes

      attr_reader :secret, :name
      filtered_attributes :secret

      def initialize(secret, name)
        @secret = secret
        @name = name
      end
    end
  end

  describe "#inspect" do
    it "filters secret by default" do
      expect(poro_class.filtered_attribute_names).to include(:secret)
    end

    it "filters out the @secret value" do
      expect(instance.inspect).to include("@secret=[FILTERED]")
    end

    it "does not filter non-sensitive attributes" do
      expect(instance.inspect).to include('@name="bolt"')
    end

    it "keeps the inspect output shape provided by super" do
      expect(instance.inspect).to start_with("#<#{poro_class}:0x")
      expect(instance.inspect).to include("@secret=[FILTERED]")
      expect(instance.inspect).to include('@name="bolt"')
    end

    context "when sensitive values are nested in hash inspect output" do
      let(:data_class) do
        Class.new do
          include Auth::Sanitizer::FilteredAttributes

          filtered_attributes :password_digest

          def initialize(identity_data)
            @identity_data = identity_data
          end
        end
      end

      it "filters symbol labels" do
        inspected = data_class.new({id: 1, password_digest: "$2a$secret"}).inspect

        expect(inspected).to include("password_digest")
        expect(inspected).to include("password_digest: [FILTERED]").or(include(":password_digest => [FILTERED]"))
        expect(inspected).not_to include("$2a$secret")
      end

      it "filters string hash keys" do
        inspected = data_class.new({"password_digest" => "$2a$secret"}).inspect

        expect(inspected).to include(%("password_digest" => [FILTERED]))
        expect(inspected).not_to include("$2a$secret")
      end

      it "filters modern symbol key labels" do
        inspected = data_class.new({password_digest: "$2a$secret"}).inspect

        if inspected.include?("password_digest:")
          expect(inspected).to include("password_digest: [FILTERED]")
        else
          expect(inspected).to include(":password_digest => [FILTERED]").or(include(":password_digest=>[FILTERED]"))
        end
        expect(inspected).not_to include("$2a$secret")
      end

      it "only filters exact configured names" do
        data_class.filtered_attributes :password

        inspected = data_class.new({password_digest: "$2a$secret", password: "plain"}).inspect

        expect(inspected).to include("password: [FILTERED]").or(include(":password => [FILTERED]"))
        expect(inspected).to include("$2a$secret")
      ensure
        data_class.filtered_attributes :password_digest
      end
    end

    context "when super inspect uses an unsupported custom shape" do
      let(:custom_base_class) do
        Class.new do
          def initialize(secret)
            @secret = secret
          end

          def inspect
            %(custom(secret -> "#{@secret}"))
          end
        end
      end

      let(:custom_class) do
        Class.new(custom_base_class) do
          include Auth::Sanitizer::FilteredAttributes

          filtered_attributes :secret
        end
      end

      it "leaves unsupported inspect output unchanged" do
        expect(custom_class.new("super-secret").inspect).to eq(%(custom(secret -> "super-secret")))
      end
    end

    context "when filter is changed" do
      before do
        @original_filter = poro_class.filtered_attribute_names
        poro_class.filtered_attributes :vanilla
      end

      after do
        poro_class.filtered_attributes(*@original_filter)
      end

      it "changes the filter" do
        expect(poro_class.filtered_attribute_names).to eq([:vanilla])
      end

      it "does not filter out the @secret value for new instances" do
        new_instance = poro_class.new("super-secret", "bolt")
        expect(new_instance.inspect).to include('@secret="super-secret"')
      end
    end

    context "when filter is empty" do
      before do
        @original_filter = poro_class.filtered_attribute_names
        poro_class.filtered_attributes
      end

      after do
        poro_class.filtered_attributes(*@original_filter)
      end

      it "changes the filter" do
        expect(poro_class.filtered_attribute_names).to be_empty
      end

      it "does not filter out the @secret value for new instances" do
        new_instance = poro_class.new("super-secret", "bolt")
        expect(new_instance.inspect).to include('@secret="super-secret"')
      end
    end

    context "when filtered_label_provider changes after initialization" do
      before do
        instance # initialize with current label
        Auth::Sanitizer.filtered_label_provider = -> { "[REDACTED]" }
      end

      after do
        Auth::Sanitizer.filtered_label_provider = Auth::Sanitizer::DEFAULT_FILTERED_LABEL_PROVIDER
      end

      it "keeps using the label captured at initialization" do
        expect(instance.inspect).to include("@secret=[FILTERED]")
        expect(instance.inspect).not_to include("@secret=[REDACTED]")
      end
    end

    context "when no filtered_attributes have ever been declared on the class" do
      let(:bare_class) do
        Class.new do
          include Auth::Sanitizer::FilteredAttributes

          def initialize(name)
            @name = name
          end
        end
      end

      it "returns an empty array from filtered_attribute_names" do
        expect(bare_class.filtered_attribute_names).to be_empty
      end

      it "does not redact any attributes in inspect" do
        instance = bare_class.new("bolt")
        expect(instance.inspect).to include('@name="bolt"')
      end
    end
  end
end
