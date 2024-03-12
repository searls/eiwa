module Eiwa
  module Tag
    class SourceLanguage < Any
      attr_reader :text, :language, :wasei, :type

      def initialize(text: nil, language: "eng", wasei: false, type: "full")
        @text = text
        @language = language
        @wasei = wasei
        @type = type
      end

      def end_self
        @text = @characters
        @language = @attrs["xml:lang"]
        @wasei = @attrs["ls_wasei"] == "y"
        @type = @attrs["ls_type"] || "full"
      end

      def eql?(other)
        @text == other.text &&
          @language == other.language &&
          @wasei == other.wasei &&
          @type == other.type
      end
      alias_method :==, :eql?

      def hash
        [@text, @language, @wasei, @type].hash
      end
    end
  end
end
