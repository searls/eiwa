module Eiwa
  module Tag
    class Any
      attr_reader :tag_name, :characters, :parent

      def start(tag_name, attrs, parent)
        @tag_name = tag_name
        @attrs = Hash[attrs]
        @parent = parent
      end

      def add_characters(s)
        @characters ||= ""
        @characters << s.chomp
      end

      def end_child(child)
      end

      def end_self
      end

      def to_s
        "<#{@tag_name}>#{@characters}</#{@tag_name}>"
      end
    end
  end
end
