# frozen_string_literal: true

require "version_gem"

require_relative "sanitizer/thing_filter"
require_relative "sanitizer/core"
require_relative "sanitizer/filtered_attributes"
require_relative "sanitizer/sanitized_logger"
require_relative "sanitizer/version"

Auth::Sanitizer::Version.class_eval do
  extend VersionGem::Basic
end
