module Eiwa
  module Tag
    class ReadingMeaning < Any
      attr_reader :rmgroup

      def end_child(child)
        @rmgroup = child if child.tag_name == "rmgroup"
      end
    end
  end
end
