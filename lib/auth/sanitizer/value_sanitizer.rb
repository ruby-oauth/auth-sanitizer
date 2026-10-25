# frozen_string_literal: true

module Auth
  module Sanitizer
    # Sanitizes arbitrary values using a configured {ThingFilter}.
    class ValueSanitizer
      # @param filtered_keys [Array<String>] Sensitive key names
      # @param label [String] Replacement label
      def initialize(filtered_keys: Auth::Sanitizer.default_filtered_keys, label: Auth::Sanitizer.filtered_label, **options)
        @thing_filter = ThingFilter.new(filtered_keys, label: label)
      end

      # Return a sanitized copy. Matching Hash keys are replaced as well as
      # their values, so a secret used as a key cannot leak through inspect.
      #
      # @param value [Object] Value to sanitize
      # @return [Object]
      def sanitize(value)
        case value
        when Hash
          value.each_with_object({}) do |(key, nested), sanitized|
            sanitized_key = sanitize(key)
            sanitized[sanitized_key] = sensitive_key?(key) ? @thing_filter.label : sanitize(nested)
          end
        when Array
          value.map { |nested| sanitize(nested) }
        when String
          sanitize_string(value)
        else
          value
        end
      end

      private

      def sensitive_key?(key)
        @thing_filter.filtered?(key)
      end

      def sanitize_string(message)
        sanitized = message.dup.scrub
        sanitized = sanitized.gsub(/(Authorization:\s*)(?:"[^"]*"|[^\r\n]+)/i, "\\1\"#{@thing_filter.label}\"")
        sanitized = sanitized.gsub(/(["'])(#{@thing_filter.pattern_source})\1(\s*:\s*)(["'])(.*?)\4/i) do
          %(#{$1}#{$2}#{$1}#{$3}#{$4}#{@thing_filter.label}#{$4})
        end
        key = @thing_filter.pattern_source
        label = @thing_filter.label
        sanitized = sanitized.gsub(/((?:"(?:#{key})"|:#{key})\s*=>\s*")[^"]*(")/i) { "#{$1}#{label}#{$2}" }
        sanitized = sanitized.gsub(/(?<!["'])((?:\b(?:#{key})):\s*")[^"]*(")/i) { "#{$1}#{label}#{$2}" }
        sanitized.gsub(/(\b(?:#{key})=)([^&\s">]+)/i, "\\1#{label}")
      end
    end
  end
end
