# frozen_string_literal: true

module Auth
  module Sanitizer
    # Logger wrapper that redacts sensitive values from debug output before delegating to the
    # underlying logger instance.
    #
    # This class is intentionally narrow in scope: it only sanitizes string messages emitted
    # through the logging path and leaves request/response behavior unchanged.
    #
    # The underlying {ThingFilter} is initialized once when the logger wrapper is
    # created, so later config changes do not alter the behavior of existing
    # logger instances.
    class SanitizedLogger
      # Create a new sanitized logger wrapper.
      #
      # @param logger [#add, #debug, #info, #warn, #error, #fatal, #unknown]
      #   The underlying logger instance that will receive sanitized messages.
      # @param filtered_keys [Array<String>]
      #   Key names whose values should be redacted in debug output.
      #   Defaults to {Auth::Sanitizer.default_filtered_keys}.
      # @param label [String]
      #   Replacement label for redacted values.
      #   Defaults to {Auth::Sanitizer.filtered_label}.
      def initialize(logger, filtered_keys: Auth::Sanitizer.default_filtered_keys, label: Auth::Sanitizer.filtered_label)
        @logger = logger
        @value_sanitizer = ValueSanitizer.new(filtered_keys: filtered_keys, label: label)
      end

      # Add a log entry after sanitizing any string payloads.
      #
      # @param severity [Integer, Symbol, String, nil] Logger severity
      # @param message [Object, nil] Optional log message
      # @param progname [Object, nil] Optional program name
      # @yieldreturn [Object] Deferred log message
      # @return [Object] The underlying logger result
      def add(severity, message = nil, progname = nil)
        if block_given?
          @logger.add(severity, sanitize(message), sanitize(progname)) { sanitize(yield) }
        else
          @logger.add(severity, sanitize(message), sanitize(progname))
        end
      end

      # Append a message to the underlying logger after sanitization.
      #
      # @param message [String] Message to append
      # @return [Object] The underlying logger result
      def <<(message)
        @logger << sanitize(message)
      end

      # Log a debug message after sanitization.
      #
      # @param progname [Object, nil] Optional program name
      # @yieldreturn [Object] Deferred log message
      # @return [Object] The underlying logger result
      def debug(progname = nil, &block)
        log(:debug, progname, &block)
      end

      # Log an info message after sanitization.
      #
      # @param progname [Object, nil] Optional program name
      # @yieldreturn [Object] Deferred log message
      # @return [Object] The underlying logger result
      def info(progname = nil, &block)
        log(:info, progname, &block)
      end

      # Log a warning message after sanitization.
      #
      # @param progname [Object, nil] Optional program name
      # @yieldreturn [Object] Deferred log message
      # @return [Object] The underlying logger result
      def warn(progname = nil, &block)
        log(:warn, progname, &block)
      end

      # Log an error message after sanitization.
      #
      # @param progname [Object, nil] Optional program name
      # @yieldreturn [Object] Deferred log message
      # @return [Object] The underlying logger result
      def error(progname = nil, &block)
        log(:error, progname, &block)
      end

      # Log a fatal message after sanitization.
      #
      # @param progname [Object, nil] Optional program name
      # @yieldreturn [Object] Deferred log message
      # @return [Object] The underlying logger result
      def fatal(progname = nil, &block)
        log(:fatal, progname, &block)
      end

      # Log an unknown-severity message after sanitization.
      #
      # @param progname [Object, nil] Optional program name
      # @yieldreturn [Object] Deferred log message
      # @return [Object] The underlying logger result
      def unknown(progname = nil, &block)
        log(:unknown, progname, &block)
      end

      # Close the underlying logger if supported.
      #
      # @return [void]
      def close
        @logger.close if @logger.respond_to?(:close)
      end

      # Access the formatter of the underlying logger if supported.
      #
      # @return [Object, nil]
      def formatter
        @logger.formatter if @logger.respond_to?(:formatter)
      end

      # Set the formatter of the underlying logger if supported.
      #
      # @param formatter [Object] Formatter object
      # @return [void]
      def formatter=(formatter)
        @logger.formatter = formatter if @logger.respond_to?(:formatter=)
      end

      # Access the logger level if supported.
      #
      # @return [Object, nil]
      def level
        @logger.level if @logger.respond_to?(:level)
      end

      # Set the logger level if supported.
      #
      # @param level [Object] Logger level
      # @return [void]
      def level=(level)
        @logger.level = level if @logger.respond_to?(:level=)
      end

      # Access the logger progname if supported.
      #
      # @return [Object, nil]
      def progname
        @logger.progname if @logger.respond_to?(:progname)
      end

      # Set the logger progname if supported.
      #
      # @param progname [Object] Logger progname
      # @return [void]
      def progname=(progname)
        @logger.progname = progname if @logger.respond_to?(:progname=)
      end

      # Report support for methods provided by the wrapped logger.
      #
      # @param method_name [Symbol] Method name to check
      # @param include_private [Boolean] Whether private methods are considered
      # @return [Boolean]
      def respond_to_missing?(method_name, include_private = false)
        @logger.respond_to?(method_name, include_private) || super
      end

      # Delegate unsupported methods to the wrapped logger.
      #
      # @param method_name [Symbol] Method to invoke
      # @param args [Array<Object>] Method arguments
      # @yield Deferred block forwarded to the wrapped logger
      # @return [Object] The delegated result
      def method_missing(method_name, *args, &block)
        return super unless @logger.respond_to?(method_name)

        @logger.public_send(method_name, *args, &block)
      end

      private

      # Dispatch a severity-specific log call after sanitization.
      #
      # @param level [Symbol] Logger method name
      # @param progname [Object, nil] Optional program name
      # @yieldreturn [Object] Deferred log message
      # @return [Object] The underlying logger result
      def log(level, progname = nil)
        if block_given?
          @logger.public_send(level, sanitize(progname)) { sanitize(yield) }
        else
          @logger.public_send(level, sanitize(progname))
        end
      end

      # Sanitize a logger message when it is a String.
      #
      # @param message [Object] Potential logger payload
      # @return [Object] Unchanged non-String payloads, sanitized String payloads
      def sanitize(message)
        return message unless message.is_a?(String)

        @value_sanitizer.sanitize(message)
      end
    end
  end
end
