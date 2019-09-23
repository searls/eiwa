require "eiwa/version"
require "eiwa/parses_jmdict_file"

module Eiwa
  class Error < StandardError; end

  def self.parse_file(filename, type: :jmdict_e, &each_entry_block)
    case type
    when :jmdict_e
      ParsesJmdictFile.new.call(filename, each_entry_block)
    else
      raise Eiwa::Error.new("Unknown file type: #{type}")
    end
  end
end
