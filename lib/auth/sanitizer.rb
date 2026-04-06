# frozen_string_literal: true

require "version_gem"
require_relative "sanitizer/version"

Auth::Sanitizer::Version.class_eval do
  extend VersionGem::Basic
end
module Auth
  module Sanitizer
    class Error < StandardError; end
    # Your code goes here...
  end
end
