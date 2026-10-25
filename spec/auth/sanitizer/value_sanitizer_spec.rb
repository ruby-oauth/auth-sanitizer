# frozen_string_literal: true

RSpec.describe Auth::Sanitizer do
  describe ".sanitize" do
    it "recursively redacts configured keys in hashes and arrays" do
      input = {
        "client_secret" => "private",
        grant_type: "refresh_token",
        "nested" => [{ "access_token" => "also-private", "keep" => "visible" }]
      }

      result = described_class.sanitize(input)

      expect(result).to eq(
        "client_secret" => "[FILTERED]",
        grant_type: "refresh_token",
        "nested" => [{ "access_token" => "[FILTERED]", "keep" => "visible" }]
      )
      expect(input["client_secret"]).to eq("private")
    end

    it "uses caller-provided keys and label" do
      result = described_class.sanitize({ "my_secret" => "private" }, filtered_keys: ["my_secret"], label: "[HIDDEN]")

      expect(result).to eq("my_secret" => "[HIDDEN]")
    end

    it "sanitizes string values using logger-supported formats" do
      result = described_class.sanitize('{"client_secret" => "private", access_token=another-secret}')

      expect(result).to include('"client_secret" => "[FILTERED]"')
      expect(result).to include("access_token=[FILTERED]")
      expect(result).not_to include("private", "another-secret")
    end

    it "returns other scalar values unchanged" do
      expect(described_class.sanitize(42)).to eq(42)
    end
  end
end
