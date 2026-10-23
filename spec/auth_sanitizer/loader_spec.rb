# frozen_string_literal: true

require "auth_sanitizer/loader"

RSpec.describe AuthSanitizer::Loader do
  describe ".load_isolated" do
    subject(:isolated) { described_class.load_isolated }

    it "returns a Sanitizer module" do
      expect(isolated).to be_a(Module)
      expect(isolated.const_get(:ThingFilter)).to be_a(Class)
    end

    it "is distinct from the top-level Auth::Sanitizer" do
      expect(isolated).not_to equal(Auth::Sanitizer)
    end

    it "provides the gem's modules inside the anonymous namespace" do
      expect(isolated.const_get(:ThingFilter)).to be_a(Class)
      expect(isolated.const_get(:SanitizedLogger)).to be_a(Class)
      expect(isolated.const_get(:Version)).to be_a(Module)
    end

    it "returns a functional ThingFilter" do
      filter_class = isolated.const_get(:ThingFilter)
      filter = filter_class.new(["secret"], label: "[GONE]")
      expect(filter.filtered?("my_secret")).to be(true)
      expect(filter.filtered?("public")).to be(false)
    end

    it "does not define additional top-level constants beyond the host's own Auth" do
      # The spec helper already loads the top-level Auth::Sanitizer; loading the
      # isolated copy must not replace or pollute it.
      original = Auth::Sanitizer
      isolated
      expect(Auth::Sanitizer).to equal(original)
    end
  end

  describe ".isolated_source" do
    def source_for(fixture)
      path = File.expand_path("../fixtures/#{fixture}", __dir__)
      described_class.send(:isolated_source, path)
    end

    context "with a file lacking the module Auth wrapper" do
      it "strips Auth::Sanitizer namespacing without removing lines" do
        source = source_for("no_wrapper.rb")
        expect(source).to include("module Sanitizer")
        expect(source).not_to include("Auth::Sanitizer")
        expect(source).to include("def ping")
      end
    end

    context "with a file lacking a trailing end line" do
      it "still produces evaluatable source" do
        source = source_for("no_closing_end.rb")
        expect(source).not_to include("Auth::Sanitizer")
        expect { Module.new.module_eval(source, "no_closing_end.rb", 1) }.not_to raise_error
      end
    end

    context "with a file using the standard wrapper" do
      it "removes the wrapper and dedents the body" do
        source = source_for("standard_wrapper.rb")
        expect(source).not_to include("module Auth")
        expect(source).to include("module Sanitizer")
        expect { Module.new.module_eval(source, "standard_wrapper.rb", 1) }.not_to raise_error
      end
    end
  end
end
