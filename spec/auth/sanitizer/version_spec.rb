# frozen_string_literal: true

require "anonymous_loader"
RSpec.describe Auth::Sanitizer::Version do
  it_behaves_like "a Version module", described_class

  it "executes the version file for coverage without redefining constants" do
    paths = [
      File.expand_path("../../../lib/auth/sanitizer/version.rb", __dir__),
      File.expand_path("../../../lib/auth/sanitizer/version_gem.rb", __dir__)
    ].select { |path| File.file?(path) }
    anonymous_namespace = AnonymousLoader.load(files: paths)

    expect(anonymous_namespace::Auth::Sanitizer::Version::VERSION).to eq(described_class::VERSION)
  end
end
