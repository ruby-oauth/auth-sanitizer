# frozen_string_literal: true

module AuthSanitizer
  # Loader for consumers that need Auth::Sanitizer without defining a top-level
  # Auth constant in the host application.
  module Loader
    FILES = %w[
      auth/sanitizer/version.rb
      auth/sanitizer/thing_filter.rb
      auth/sanitizer/core.rb
      auth/sanitizer/filtered_attributes.rb
      auth/sanitizer/sanitized_logger.rb
    ].freeze

    class << self
      # Load Auth::Sanitizer into an anonymous namespace and return the
      # nested Auth::Sanitizer module from that namespace.
      #
      # This uses Module#module_eval with explicit file and line metadata so it
      # works on Ruby 2.2+, where Kernel.load(path, module) is unavailable.
      #
      # @return [Module] isolated Auth::Sanitizer module
      def load_isolated
        namespace = Module.new
        auth_namespace = Module.new
        namespace.const_set(:Auth, auth_namespace)
        auth_namespace.const_set(:Auth, auth_namespace)

        FILES.each do |relative_path|
          path = File.expand_path("../#{relative_path}", __dir__)
          auth_namespace.module_eval(isolated_source(path), path, 1)
        end

        namespace.const_get(:Auth).const_get(:Sanitizer)
      end

      private

      # Remove the public top-level Auth wrapper before evaluating a file inside
      # the anonymous Auth namespace. This keeps the normal files unchanged while
      # avoiding Object::Auth leakage on runtimes where Module#module_eval still
      # resolves nested module declarations through Object.
      def isolated_source(path)
        lines = File.readlines(path)
        wrapper_index = lines.index("module Auth\n")
        return lines.join unless wrapper_index

        lines.delete_at(wrapper_index)
        closing_index = lines.rindex("end\n")
        lines.delete_at(closing_index) if closing_index

        lines[(wrapper_index)..].map! do |line|
          line.start_with?("  ") ? line[2..] : line
        end
        lines.join
      end
    end
  end
end
