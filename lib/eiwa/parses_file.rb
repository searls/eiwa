require "nokogiri"
require_relative "jmdict/doc"
require_relative "kanjidic/doc"

module Eiwa
  class ParsesFile
    def call(filename, type, each_entry_block)
      if each_entry_block.nil?
        entries = []
        each_entry_block ||= ->(e) { entries << e }
      end

      doc_for(type).new(each_entry_block).tap do |doc|
        Nokogiri::XML::SAX::Parser.new(doc).parse_file(filename) do |ctx|
          ctx.recovery = true
        end
      end

      entries
    end

    private

    def doc_for(type)
      case type
      when :jmdict_e
        Jmdict::Doc
      when :kanjidic2
        Kanjidic::Doc
      else
        raise Eiwa::Error.new("Unknown file type: #{type}")
      end
    end
  end
end
