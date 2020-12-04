# frozen_string_literal: true

require "assume/version"

module Assume
  class BrokenAssumption < StandardError; end
  @@assumption_handler = nil
  @@enabled = false

  RAISE_HANDLER = lambda do |result, block|
    filename, line = block.source_location
    line_content = File.readlines(filename)[line - 1]

    raise BrokenAssumption, "\nin #{filename}\nsource" \
                            "code (line #{line}):\n#{line_content}\n" \
                            "result was: #{result.inspect}"
  end

  def assume(&block)
    raise ArgumentError, "assumptions need a block" if block.nil?
    return unless @@enabled

    result = block.call

    unless result
      Assume.broken_assumption_handler.call(result, block)
    end

    nil
  end
  alias assumption assume

  def handle_broken_assumptions(&block)
    @assumption_handler = block
  end

  def self.enable!
    @@enabled = true
  end

  def self.broken_assumption_handler
    @@assumption_handler || RAISE_HANDLER
  end
end
