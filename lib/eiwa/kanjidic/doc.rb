module Eiwa
  module Kanjidic
    TAGS = {
      "character" => Tag::Character,
      "misc" => Tag::Bag,
      "reading_meaning" => Tag::ReadingMeaning,
      "rmgroup" => Tag::List
    }

    class Doc < Nokogiri::XML::SAX::Document
      def initialize(each_entry_block)
        @each_entry_block = each_entry_block
        @current = nil
      end

      def start_element(name, attrs)
        parent = @current
        @current = (TAGS[name] || Tag::Other).new
        @current.start(name, attrs, parent)
      end

      def end_element(name)
        raise Eiwa::Error.new("Parsing error. Expected <#{@current.tag_name}> to close before <#{name}>") if @current.tag_name != name
        ending = @current
        ending.end_self
        if ending.is_a?(Tag::Character)
          @each_entry_block&.call(ending)
        end

        @current = ending.parent
        @current&.end_child(ending)
      end

      def characters(s)
        @current.add_characters(s)
      end

      def error(msg)
        raise Eiwa::Error.new("Parsing error: #{msg}")
      end
    end
  end
end
