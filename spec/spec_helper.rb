# frozen_string_literal: true

# External gem dependencies
require "logger"

# Family libraries
require "kettle/test/rspec"

# Library configs
require_relative "config/byebug"

# RSpec Configs
require_relative "config/rspec/rspec_core"

# NOTE: Gemfiles for older rubies won't have kettle-soup-cover.
#       The rescue LoadError handles that scenario.
begin
  require "kettle-soup-cover"
  if Kettle::Soup::Cover::DO_COV
    # Requiring simplecov loads the project-local `.simplecov`.
    require "simplecov"
    require "kettle/soup/cover/config"
    SimpleCov.start
  end
rescue LoadError => error
  # check the error message, and re-raise if not what is expected
  raise error unless error.message.include?("kettle")
end

# This gem
require "auth/sanitizer"
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
