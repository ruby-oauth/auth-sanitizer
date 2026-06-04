# frozen_string_literal: true

module Auth
  module Sanitizer
    # Mixin that redacts sensitive instance variables in `#inspect` output.
    #
    # Classes include this module and declare which attribute names should be
    # filtered via {.filtered_attributes}. Matching and replacement behavior is
    # delegated to {ThingFilter}, which is initialized once per object.
    #
    # This means existing objects keep the filter configuration that was present
    # when they were initialized, even if global config or class-level filter
    # declarations change later.
    #
    # The label used for redaction is resolved from {Auth::Sanitizer.filtered_label}
    # at object initialization time. Host gems may customize this by installing a
    # provider via {Auth::Sanitizer.filtered_label_provider=}.
    module FilteredAttributes
      class << self
        # Hook invoked when the module is included. Extends the including class with
        # class-level helpers and prepends the initializer hook.
        #
        # @param [Class] base The including class
        # @return [void]
        def included(base)
          base.extend(ClassMethods)
          base.prepend(InitializerMethods)
        end
      end

      # Initializer hook that snapshots the thing filter for this object.
      #
      # The snapshot captures both the class-level filtered attribute names and
      # the current {Auth::Sanitizer.filtered_label} value.
      module InitializerMethods
        def initialize(*args, &block)
          super
          @thing_filter = ThingFilter.new(
            self.class.filtered_attribute_names,
            label: Auth::Sanitizer.filtered_label
          )
        end
      end

      # Class-level helpers for configuring filtered attributes.
      module ClassMethods
        class << self
          # Declare attributes that should be redacted in inspect output.
          #
          # @param [Array<Symbol, String>] attributes One or more attribute names
          # @return [void]
          def filtered_attributes(base, *attributes)
            base.instance_variable_set(:@filtered_attribute_names, attributes.map(&:to_sym))
          end

          # The configured attribute names to filter.
          #
          # @param [Class] base The class to get filtered attributes for
          # @return [Array<Symbol>]
          def filtered_attribute_names(base)
            return [] unless base.instance_variable_defined?(:@filtered_attribute_names)

            base.instance_variable_get(:@filtered_attribute_names) || []
          end
        end

        # Declare attributes that should be redacted in inspect output.
        #
        # @param [Array<Symbol, String>] attributes One or more attribute names
        # @return [void]
        def filtered_attributes(*attributes)
          ClassMethods.filtered_attributes(self, *attributes)
        end

        # The configured attribute names to filter.
        #
        # @return [Array<Symbol>]
        def filtered_attribute_names
          ClassMethods.filtered_attribute_names(self)
        end
      end

      # The initialized thing filter used by this object.
      #
      # This is a per-instance snapshot created during initialization.
      #
      # @return [ThingFilter]
      def thing_filter
        @thing_filter
      end

      # Custom inspect that redacts configured attributes.
      #
      # @return [String]
      def inspect
        inspected = super
        return inspected if thing_filter.things.empty?

        thing_filter.things.each_with_object(inspected.dup) do |thing, memo|
          redact_inspected_value!(memo, thing)
        end
      end

      private

      INSPECTED_STRING_VALUE = /"(?:(?:\\.)|[^"\\])*"/
      private_constant :INSPECTED_STRING_VALUE

      def redact_inspected_value!(inspected, thing)
        escaped = Regexp.escape(thing)
        patterns = [
          /(@#{escaped}=)#{INSPECTED_STRING_VALUE}/,
          /([,{]\s*#{escaped}:\s*)#{INSPECTED_STRING_VALUE}/,
          /([,{]\s*:#{escaped}\s*=>\s*)#{INSPECTED_STRING_VALUE}/,
          /([,{]\s*"#{escaped}"\s*=>\s*)#{INSPECTED_STRING_VALUE}/
        ]

        patterns.each do |pattern|
          inspected.gsub!(pattern) { "#{$1}#{thing_filter.label}" }
        end
        inspected
      end
    end
  end
end
