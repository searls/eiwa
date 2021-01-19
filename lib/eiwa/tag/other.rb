module Eiwa
  module Tag
    class Other < Any
      attr_reader :attrs

      def text
        @characters
      end
    end
  end
end
