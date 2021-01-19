module Eiwa
  module Tag
    class Spelling < Any
      attr_reader :text, :frequency_tags, :info_tags

      def initialize
        @frequency_tags = []
        @info_tags = []
      end

      def end_child(child)
        case child.tag_name
        when "keb"
          @text = child.characters
        when "ke_pri"
          @frequency_tags << child.characters.to_sym
        when "ke_inf"
          @info_tags << child
        end
      end
    end
  end
end
