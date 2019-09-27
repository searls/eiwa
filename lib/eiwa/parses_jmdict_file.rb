require "nokogiri"
require_relative "jmdict_doc"

module Eiwa
  class ParsesJmdictFile
    def call(filename, each_entry_block)
      if each_entry_block.nil?
        entries = []
        each_entry_block ||= ->(e) { entries << e }
      end

      JmdictDoc.new(each_entry_block).tap do |doc|
        Nokogiri::XML::SAX::Parser.new(doc).parse_file(filename) do |ctx|
          ctx.recovery = true
        end
      end

      entries
    end
  end
end
