module Eiwa
  module Tag
    class Meaning < Any
      attr_reader :parts_of_speech, :definitions, :misc_tags,
        :cross_references, :restricted_to_readings, :restricted_to_spellings,
        :antonyms, :fields, :source_languages, :dialects, :comments

      def initialize
        @parts_of_speech = []
        @definitions = []
        @misc_tags = []
        @cross_references = []
        @restricted_to_readings = []
        @restricted_to_spellings = []
        @antonyms = []
        @fields = []
        @source_languages = []
        @dialects = []
        @comments = []
      end

      def end_child(child)
        case child.tag_name
        when "pos"
          @parts_of_speech << child
        when "gloss"
          @definitions << child
        when "misc"
          @misc_tags << child
        when "field"
          @fields << child
        when "xref"
          @cross_references << child
        when "ant"
          @antonyms << child
        when "stagr"
          @restricted_to_readings << child.characters
        when "stagk"
          @restricted_to_spellings << child.characters
        when "lsource"
          @source_languages << child
        when "dial"
          @dialects << child
        when "s_inf"
          @comments << child.characters
        end
      end

      def trickle_down(previous)
        @parts_of_speech = previous.parts_of_speech if @parts_of_speech.empty?
        @misc_tags = previous.misc_tags if @misc_tags.empty?
      end
    end
  end
end
