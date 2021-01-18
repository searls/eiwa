module Eiwa
  module Tag
    class Antonym < Any
      attr_reader :text, :sense_ordinal

      def initialize(text: nil, sense_ordinal: nil)
        @text = text
        @sense_ordinal = sense_ordinal
      end

      def end_self
        parts = @characters.split("・")
        @text = parts[0]
        @sense_ordinal = parts[1]&.to_i
      end

      def eql?(other)
        @text == other.text &&
          @sense_ordinal == other.sense_ordinal
      end
      alias_method :==, :eql?

      def hash
        @text.hash + @sense_ordinal.hash
      end
    end
  end
end
