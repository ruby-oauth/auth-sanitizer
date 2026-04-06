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
  require "simplecov" if Kettle::Soup::Cover::DO_COV # `.simplecov` is run here!
rescue LoadError => error
  # check the error message, and re-raise if not what is expected
  raise error unless error.message.include?("kettle")
end

# This gem
require "auth/sanitizer"
