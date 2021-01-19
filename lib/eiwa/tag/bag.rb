module Eiwa
  module Tag
    # For simple elements that contain child element_name, value pairs that could plop into a hash nicely
    class Bag < Any
      attr_reader :values

      def initialize
        @values = {}
      end

      def [](key)
        @values[key]
      end

      def end_child(child)
        # Don't overwrite, first dupe tends to be authorative one
        @values[child.tag_name] = child.text unless @values.key?(child.tag_name)
      end
    end
  end
end
