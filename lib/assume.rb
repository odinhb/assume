# frozen_string_literal: true

require "assume/version"

module Assume
  class BadAssumption < StandardError; end

  DEFAULT_HANDLER = lambda do |result, block|
    filename, line = block.source_location
    begin
      lines = File.readlines(filename)
      line_content = lines[line - 1]
    rescue Errno::ENOENT => err
      line_content = "<unable to open source code file>"
    end

    raise BadAssumption, "\nin #{filename}\nsource" \
                         "code (line #{line}):\n#{line_content}\n" \
                         "result was: #{result.inspect}"
  end

  def assume(&block)
    raise ArgumentError, "assumptions need a block" if block.nil?
    return unless Assume.enabled?

    result = block.call

    unless result
      Assume.broken_assumption_handler.call(result, block)
    end

    nil
  end
  alias assumption assume

  class << self
    def handler=(handler)
      @assumption_handler = handler
    end

    def enabled=(val)
      @enabled = !!val
    end

    def enabled?
      @enabled
    end

    def broken_assumption_handler
      @assumption_handler || DEFAULT_HANDLER
    end
  end
end

Assume.enabled = false
