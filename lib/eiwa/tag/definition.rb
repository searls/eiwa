module Eiwa
  module Tag
    class Definition < Any
      attr_reader :text, :language, :gender, :type

      def initialize(text: nil, language: "eng", gender: nil, type: nil)
        @text = text
        @language = language
        @gender = gender
        @type = type
      end

      def end_self
        @text = @characters
        @language = @attrs["xml:lang"]
        @gender = @attrs["g_gend"]
        @type = @attrs["g_type"]
      end

      def literal?
        @type == "lit"
      end

      def figurative?
        @type == "fig"
      end

      def explanation?
        @type == "expl"
      end

      def eql?(other)
        @text == other.text &&
          @language == other.language &&
          @gender == other.gender &&
          @type == other.type
      end
      alias_method :==, :eql?

      def hash
        [@text, @language, @gender, @type].hash
      end
    end
  end
end
