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
        expect(poro_class.filtered_attribute_names).to eq([])
      end

      it "does not filter out the @secret value for new instances" do
        new_instance = poro_class.new("super-secret", "bolt")
        expect(new_instance.inspect).to include('@secret="super-secret"')
      end
    end

    context "when filtered_label_provider changes after initialization" do
      before do
        @original_provider = Auth::Sanitizer.instance_variable_get(:@filtered_label_provider)
        instance # initialize with current label
        Auth::Sanitizer.filtered_label_provider = -> { "[REDACTED]" }
      end

      after do
        Auth::Sanitizer.filtered_label_provider = @original_provider
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
        expect(bare_class.filtered_attribute_names).to eq([])
      end

      it "does not redact any attributes in inspect" do
        instance = bare_class.new("bolt")
        expect(instance.inspect).to include('@name="bolt"')
      end
    end
  end
end
