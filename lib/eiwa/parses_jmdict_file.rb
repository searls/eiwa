require "nokogiri"
require_relative "jmdict_doc"

module Eiwa
  class ParsesJmdictFile
    def call(filename, each_entry_block)
      JmdictDoc.new(each_entry_block).tap do |doc|
        Nokogiri::XML::SAX::Parser.new(doc).parse_file(filename) do |ctx|
          ctx.recovery = true
        end
      end.result
    end
  end
end
