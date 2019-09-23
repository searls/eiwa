require_relative "any"

module Eiwa
  module Tag
    class Reading < Any
      attr_accessor :text, :frequency_tags

      def initialize
        @frequency_tags = []
      end

      def end_child(child)
        case child.tag_name
        when "reb"
          @text = child.characters
        when "re_pri"
          @frequency_tags << child.characters.to_sym
        end
      end
    end
  end
end
