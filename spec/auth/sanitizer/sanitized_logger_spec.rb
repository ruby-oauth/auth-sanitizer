# frozen_string_literal: true

RSpec.describe Auth::Sanitizer::SanitizedLogger do
  subject(:logger) { described_class.new(underlying) }

  let(:io) { StringIO.new }
  # A minimal logger that implements only #add, so every respond_to? guard
  # for the optional methods (formatter, level, progname, close) returns false.
  let(:bare_logger) do
    Class.new do
      attr_reader :messages

      def initialize
        @messages = []
      end

      def add(_severity, message = nil, _progname = nil)
        @messages << message
      end

      def debug(msg = nil)
        @messages << (block_given? ? yield : msg)
      end
    end.new
  end
  let(:underlying) { Logger.new(io) }

  describe "#initialize" do
    it "accepts custom filtered_keys and label" do
      custom = described_class.new(underlying, filtered_keys: ["my_secret"], label: "[GONE]")
      expect(custom).to be_a(described_class)
    end
  end

  describe "#add" do
    it "sanitizes message and progname without a block" do
      logger.add(Logger::DEBUG, "access_token=abc123", "progname")
      io.rewind
      expect(io.read).to include("[FILTERED]")
      expect(io.read).not_to include("abc123")
    end

    it "sanitizes the block payload and message/progname when given a block" do
      logger.add(Logger::DEBUG, nil, nil) { "access_token=abc123" }
      io.rewind
      content = io.read
      expect(content).to include("[FILTERED]")
      expect(content).not_to include("abc123")
    end
  end

  describe "#<<" do
    it "sanitizes and appends a raw string to the underlying logger" do
      logger << "access_token=abc123"
      io.rewind
      expect(io.read).to include("[FILTERED]")
      expect(io.read).not_to include("abc123")
    end
  end

  describe "severity methods" do
    %i[debug info warn error fatal unknown].each do |level|
      describe "##{level}" do
        it "sanitizes a string progname" do
          logger.public_send(level, "access_token=abc123")
          io.rewind
          expect(io.read).to include("[FILTERED]")
          expect(io.read).not_to include("abc123")
        end

        it "sanitizes a block payload" do
          logger.public_send(level) { "access_token=abc123" }
          io.rewind
          expect(io.read).to include("[FILTERED]")
          expect(io.read).not_to include("abc123")
        end
      end
    end
  end

  describe "sanitization patterns" do
    it "redacts Authorization header values" do
      logger.debug("Authorization: Bearer super-secret-token")
      io.rewind
      expect(io.read).to include('"[FILTERED]"')
      expect(io.read).not_to include("super-secret-token")
    end

    it "redacts JSON key-value pairs for configured keys" do
      logger.debug('{"access_token": "abc123"}')
      io.rewind
      expect(io.read).to include("[FILTERED]")
      expect(io.read).not_to include("abc123")
    end

    it "redacts single-quoted JSON key-value pairs" do
      logger.debug("{'client_secret': 'abc123'}")
      io.rewind
      expect(io.read).to include("[FILTERED]")
      expect(io.read).not_to include("abc123")
    end

    it "redacts query-string / form-encoded values for configured keys" do
      logger.debug("access_token=abc123&foo=bar")
      io.rewind
      expect(io.read).to include("[FILTERED]")
      expect(io.read).not_to include("abc123")
    end

    it "passes non-String messages through unchanged" do
      expect { logger.debug(42) }.not_to raise_error
    end

    it "does not redact values for non-configured keys" do
      logger.debug("foo=bar")
      io.rewind
      expect(io.read).to include("foo=bar")
    end
  end

  describe "#close" do
    it "delegates to the underlying logger when supported" do
      expect(underlying).to receive(:close)
      logger.close
    end

    it "does nothing when the underlying logger does not respond to #close" do
      silent = described_class.new(bare_logger)
      expect { silent.close }.not_to raise_error
    end
  end

  describe "#formatter" do
    it "delegates to the underlying logger when supported" do
      expect(logger.formatter).to eq(underlying.formatter)
    end

    it "returns nil when the underlying logger does not respond to #formatter" do
      silent = described_class.new(bare_logger)
      expect(silent.formatter).to be_nil
    end
  end

  describe "#formatter=" do
    it "delegates to the underlying logger when supported" do
      fmt = proc { |_s, _d, _p, msg| msg }
      logger.formatter = fmt
      expect(underlying.formatter).to eq(fmt)
    end

    it "does nothing when the underlying logger does not respond to #formatter=" do
      silent = described_class.new(bare_logger)
      expect { silent.formatter = proc {} }.not_to raise_error
    end
  end

  describe "#level" do
    it "delegates to the underlying logger when supported" do
      expect(logger.level).to eq(underlying.level)
    end

    it "returns nil when the underlying logger does not respond to #level" do
      silent = described_class.new(bare_logger)
      expect(silent.level).to be_nil
    end
  end

  describe "#level=" do
    it "delegates to the underlying logger when supported" do
      logger.level = Logger::WARN
      expect(underlying.level).to eq(Logger::WARN)
    end

    it "does nothing when the underlying logger does not respond to #level=" do
      silent = described_class.new(bare_logger)
      expect { silent.level = Logger::WARN }.not_to raise_error
    end
  end

  describe "#progname" do
    it "delegates to the underlying logger when supported" do
      underlying.progname = "myapp"
      expect(logger.progname).to eq("myapp")
    end

    it "returns nil when the underlying logger does not respond to #progname" do
      silent = described_class.new(bare_logger)
      expect(silent.progname).to be_nil
    end
  end

  describe "#progname=" do
    it "delegates to the underlying logger when supported" do
      logger.progname = "myapp"
      expect(underlying.progname).to eq("myapp")
    end

    it "does nothing when the underlying logger does not respond to #progname=" do
      silent = described_class.new(bare_logger)
      expect { silent.progname = "myapp" }.not_to raise_error
    end
  end

  describe "#respond_to_missing?" do
    it "returns true for methods the underlying logger responds to" do
      expect(logger.respond_to?(:reopen)).to be(true)
    end

    it "returns false for methods neither the wrapper nor the underlying logger have" do
      expect(logger.respond_to?(:nonexistent_method_xyz)).to be(false)
    end
  end

  describe "#method_missing" do
    it "delegates unknown methods to the underlying logger" do
      expect(underlying).to receive(:reopen).with(io)
      logger.reopen(io)
    end

    it "raises NoMethodError for methods neither logger supports" do
      expect { logger.nonexistent_method_xyz }.to raise_error(NoMethodError)
    end
  end
end
