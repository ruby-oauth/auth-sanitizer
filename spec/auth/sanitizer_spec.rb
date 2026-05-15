# frozen_string_literal: true

RSpec.describe Auth::Sanitizer do
  it "has a version number" do
    expect(Auth::Sanitizer::VERSION).not_to be_nil
  end

  describe ".filtered_label" do
    it "returns the default label when no provider is installed" do
      expect(described_class.filtered_label).to eq("[FILTERED]")
    end
  end

  describe ".filtered_label_provider=" do
    around do |example|
      example.run
      described_class.filtered_label_provider = described_class::DEFAULT_FILTERED_LABEL_PROVIDER
    end

    it "allows replacing the label with a custom provider" do
      described_class.filtered_label_provider = -> { "[REDACTED]" }
      expect(described_class.filtered_label).to eq("[REDACTED]")
    end
  end

  describe ".default_filtered_keys" do
    it "returns an array of default key names" do
      expect(described_class.default_filtered_keys).to include("access_token", "client_secret", "token")
    end
  end
end
