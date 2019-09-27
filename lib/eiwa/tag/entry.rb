require_relative "any"

module Eiwa
  module Tag
    class Entry < Any
      attr_reader :id, :spellings, :readings, :meanings

      def initialize
        @spellings = []
        @readings = []
        @meanings = []
      end

      def text
        (@spellings + @readings).first.text
      end

      def end_child(child)
        case child.tag_name
        when "ent_seq"
          @id = child.characters.to_i
        when "k_ele"
          @spellings << child
        when "r_ele"
          @readings << child
        when "sense"
          child.trickle_down(@meanings.last) unless @meanings.last.nil?
          @meanings << child
        end
      end
    end
  end
end
