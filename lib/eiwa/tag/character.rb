module Eiwa
  module Tag
    class Character < Any
      attr_reader :text,
        :grade, :stroke_count, :freq, :jlpt,
        :onyomi, :kunyomi, :meanings

      def end_child(child)
        if child.tag_name == "literal"
          @text = child.text
        elsif child.tag_name == "reading_meaning"
          @onyomi = child.rmgroup.items.select { |item| item.name == "reading" && item.attrs["r_type"] == "ja_on" }.map(&:text)
          @kunyomi = child.rmgroup.items.select { |item| item.name == "reading" && item.attrs["r_type"] == "ja_kun" }.map(&:text)
          @meanings = child.rmgroup.items.select { |item| item.name == "meaning" && (item.attrs["m_lang"].nil? || item.attrs["m_lang"] == "en") }.map(&:text)
        elsif child.tag_name == "misc"
          @grade = child["grade"]&.to_i
          @stroke_count = child["stroke_count"]&.to_i
          @freq = child["freq"]&.to_i
          @jlpt = child["jlpt"]&.to_i
        end
      end
    end
  end
end
