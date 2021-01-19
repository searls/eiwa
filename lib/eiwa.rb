require "eiwa/version"

require "eiwa/tag/any"
require "eiwa/tag/character"
require "eiwa/tag/bag"
require "eiwa/tag/list"
require "eiwa/tag/reading_meaning"
require "eiwa/tag/entry"
require "eiwa/tag/spelling"
require "eiwa/tag/reading"
require "eiwa/tag/meaning"
require "eiwa/tag/entity"
require "eiwa/tag/cross_reference"
require "eiwa/tag/antonym"
require "eiwa/tag/source_language"
require "eiwa/tag/definition"
require "eiwa/tag/other"

require "eiwa/parses_file"

module Eiwa
  class Error < StandardError; end

  def self.parse_file(filename, type: :jmdict_e, &each_entry_block)
    ParsesFile.new.call(filename, type, each_entry_block)
  end
end
