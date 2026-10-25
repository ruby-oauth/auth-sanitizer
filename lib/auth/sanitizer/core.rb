# frozen_string_literal: true

# Top-level namespace for authentication-adjacent helpers.
module Auth
  # Credential redaction for inspect output and debug logging.
  module Sanitizer
    # Error raised for auth-sanitizer failures.
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

    # Default callable used to provide the filtered replacement label.
    DEFAULT_FILTERED_LABEL_PROVIDER = -> { DEFAULT_FILTERED_LABEL }

    filtered_label_provider = DEFAULT_FILTERED_LABEL_PROVIDER
    filtered_label_provider_mutex = Mutex.new

    # Returns the current filtered label by calling the installed provider.
    #
    # Host gems may install a provider that reads from their own config by
    # calling {filtered_label_provider=}.
    #
    # @return [String]
    define_singleton_method(:filtered_label) do
      filtered_label_provider_mutex.synchronize { filtered_label_provider }.call
    end

    # Install a custom provider for the filtered label.
    #
    # The provider callable is invoked each time a new {FilteredAttributes}- or
    # {SanitizedLogger}-bearing object is initialized, allowing the label to track a host gem's
    # live configuration while still being snapshotted per object instance.
    #
    # @return [void]
    # @example Delegate to a host gem's config
    #   Auth::Sanitizer.filtered_label_provider = -> { MyGem.config[:filtered_label] }
    define_singleton_method(:filtered_label_provider=) do |provider|
      filtered_label_provider_mutex.synchronize do
        filtered_label_provider = provider
      end
    end

    class << self
      # Returns the default set of key names filtered from debug log output.
      #
      # Host gems may override this by passing `filtered_keys:` directly to
      # {SanitizedLogger#initialize}.
      #
      # @return [Array<String>]
      def default_filtered_keys
        DEFAULT_FILTERED_KEYS
      end

      # Sanitize a value using the configured key names and replacement label.
      # Hashes and arrays are traversed recursively; strings are filtered using
      # the same formats supported by {SanitizedLogger}.
      #
      # @param value [Object] Value to sanitize
      # @param filtered_keys [Array<String>] Key names whose values should be redacted
      # @param label [String] Replacement label for redacted values
      # @return [Object] Sanitized copy of the value
      def sanitize(value, filtered_keys: default_filtered_keys, label: filtered_label, **options)
        ValueSanitizer.new(filtered_keys: filtered_keys, label: label, **options).sanitize(value)
      end
    end
  end
end
