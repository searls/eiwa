module Eiwa
  module Tag
    class CrossReference < Any
      attr_reader :text, :reading, :sense_ordinal

      def initialize(text: nil, reading: nil, sense_ordinal: nil)
        @text = text
        @reading = reading
        @sense_ordinal = sense_ordinal
      end

      def end_self
        parts = @characters.split("・")
        @text = parts.first
        @reading = parts[1..-1].find { |part| /[^0-9]/.match(part) }
        @sense_ordinal = parts.find { |part| /^[0-9]+$/.match(part) }&.to_i
      end

      def eql?(other)
        @text == other.text &&
          @reading == other.reading &&
          @sense_ordinal == other.sense_ordinal
      end
      alias_method :==, :eql?

      def hash
        @text.hash + @reading.hash + @sense_ordinal.hash
      end
    end
  end
end
