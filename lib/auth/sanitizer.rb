# frozen_string_literal: true

require "version_gem"
require_relative "sanitizer/version"
require_relative "sanitizer/thing_filter"
require_relative "sanitizer/filtered_attributes"
require_relative "sanitizer/sanitized_logger"

Auth::Sanitizer::Version.class_eval do
  extend VersionGem::Basic
end

module Auth
  module Sanitizer
    class Error < StandardError; end

    # Default keys filtered from debug log output.
    DEFAULT_FILTERED_KEYS = %w[
      access_token
      refresh_token
      id_token
      client_secret
      assertion
      code_verifier
      token
    ].freeze

    # Default replacement label for redacted values.
    DEFAULT_FILTERED_LABEL = "[FILTERED]"

    @filtered_label_provider = -> { DEFAULT_FILTERED_LABEL }

    class << self
      # Returns the current filtered label by calling the installed provider.
      #
      # Host gems may install a provider that reads from their own config by
      # calling {filtered_label_provider=}.
      #
      # @return [String]
      def filtered_label
        @filtered_label_provider.call
      end

      # Install a custom provider for the filtered label.
      #
      # The provider is called each time a new {FilteredAttributes}- or
      # {SanitizedLogger}-bearing object is initialized, allowing the label to
      # track a host gem's live configuration while still being snapshotted per
      # object instance.
      #
      # @example Delegate to a host gem's config
      #   Auth::Sanitizer.filtered_label_provider = -> { MyGem.config[:filtered_label] }
      #
      # @param [#call] provider A callable that returns the label string
      # @return [void]
      attr_writer :filtered_label_provider

      # Returns the default set of key names filtered from debug log output.
      #
      # Host gems may override this by passing `filtered_keys:` directly to
      # {SanitizedLogger#initialize}.
      #
      # @return [Array<String>]
      def default_filtered_keys
        DEFAULT_FILTERED_KEYS
      end
    end
  end
end
