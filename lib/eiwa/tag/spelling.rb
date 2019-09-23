require_relative "any"

module Eiwa
  module Tag
    class Spelling < Any
      attr_reader :text, :frequency_tags

      def initialize
        @frequency_tags = []
      end

      def end_child(child)
        case child.tag_name
        when "keb"
          @text = child.characters
        when "ke_pri"
          @frequency_tags << child.characters.to_sym
        end
      end
    end
  end
end
