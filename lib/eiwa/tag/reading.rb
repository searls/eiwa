module Eiwa
  module Tag
    class Reading < Any
      attr_reader :text, :frequency_tags, :info_tags

      def initialize
        @frequency_tags = []
        @info_tags = []
        @imprecise_reading = false
      end

      def imprecise_reading?
        @imprecise_reading
      end

      def end_child(child)
        case child.tag_name
        when "reb"
          @text = child.characters
        when "re_pri"
          @frequency_tags << child.characters.to_sym
        when "re_inf"
          @info_tags << child
        when "re_nokanji"
          @imprecise_reading = true
        end
      end
    end
  end
end
