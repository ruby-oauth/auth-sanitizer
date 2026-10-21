# frozen_string_literal: true

require "anonymous_loader"
require "auth/sanitizer"
RSpec.describe Auth::Sanitizer::Version do
  it_behaves_like "a Version module", described_class

  it "executes the version file for coverage without redefining constants" do
    dir = File.expand_path("../../../lib/auth/sanitizer", __dir__)
    paths = %w[version.rb version_gem.rb].map { |file| File.join(dir, file) }.select { |path| File.file?(path) }
    anonymous_namespace = AnonymousLoader.load(files: paths)

    expect(anonymous_namespace::Auth::Sanitizer::Version::VERSION).to eq(described_class::VERSION)
  end
end
