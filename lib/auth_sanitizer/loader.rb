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
        FILES.each do |relative_path|
          path = File.expand_path("../#{relative_path}", __dir__)
          namespace.module_eval(File.read(path), path, 1)
        end
        namespace.const_get(:Auth).const_get(:Sanitizer)
      end
    end
  end
end
