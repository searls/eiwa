module Eiwa
  module Tag
    # For containers of lists or repeated elements
    class List < Any
      Item = Struct.new(:name, :attrs, :text, keyword_init: true)

      attr_reader :items

      def initialize
        @items = []
      end

      def end_child(child)
        @items << Item.new(name: child.tag_name, attrs: child.attrs, text: child.text)
      end
    end
  end
end
