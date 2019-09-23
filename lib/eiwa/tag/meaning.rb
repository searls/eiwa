require_relative "any"

module Eiwa
  module Tag
    class Meaning < Any
      attr_accessor :parts_of_speech, :definitions

      def initialize
        @parts_of_speech = []
        @definitions = []
      end

      def end_child(child)
        case child.tag_name
        when "pos"
          @parts_of_speech << child.entity
        when "gloss"
          @definitions << child.characters
        end
      end
    end
  end
end
