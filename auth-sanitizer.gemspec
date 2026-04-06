# frozen_string_literal: true

require_relative "lib/auth/sanitizer/version"

Gem::Specification.new do |spec|
  spec.name = "auth-sanitizer"
  spec.version = Auth::Sanitizer::VERSION
  spec.authors = ["Peter H. Boling"]
  spec.email = ["peter.boling@gmail.com"]

  spec.summary = "TODO: Write a short summary, because RubyGems requires one."
  spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.2.0"
  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.add_development_dependency("kettle-dev", "~> 2.0")                  # ruby >= 2.3.0
  spec.add_development_dependency("bundler-audit", "~> 0.9.3")                      # ruby >= 2.0.0
  spec.add_development_dependency("rake", "~> 13.0")                                # ruby >= 2.2.0
  spec.add_development_dependency("require_bench", "~> 1.0", ">= 1.0.4")            # ruby >= 2.2.0
  spec.add_development_dependency("appraisal2", "~> 3.0", ">= 3.0.6")               # ruby >= 1.8.7, for testing against multiple versions of dependencies
  spec.add_development_dependency("kettle-test", "~> 1.0", ">= 1.0.10")              # ruby >= 2.3
  spec.add_development_dependency("ruby-progressbar", "~> 1.13")                    # ruby >= 0
  spec.add_development_dependency("stone_checksums", "~> 1.0", ">= 1.0.3")          # ruby >= 2.2.0
  spec.add_development_dependency("gitmoji-regex", "~> 1.0", ">= 1.0.3")            # ruby >= 2.3.0
end
