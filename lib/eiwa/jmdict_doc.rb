require_relative "tag/entry"
require_relative "tag/spelling"
require_relative "tag/reading"
require_relative "tag/meaning"
require_relative "tag/entity"
require_relative "tag/cross_reference"
require_relative "tag/antonym"
require_relative "tag/source_language"
require_relative "tag/definition"
require_relative "tag/other"

require_relative "jmdict_entities"

module Eiwa
  TAGS = {
    "entry" => Tag::Entry,
    "k_ele" => Tag::Spelling,
    "r_ele" => Tag::Reading,
    "sense" => Tag::Meaning,
    "pos" => Tag::Entity,
    "misc" => Tag::Entity,
    "dial" => Tag::Entity,
    "field" => Tag::Entity,
    "ke_inf" => Tag::Entity,
    "re_inf" => Tag::Entity,
    "xref" => Tag::CrossReference,
    "ant" => Tag::Antonym,
    "lsource" => Tag::SourceLanguage,
    "gloss" => Tag::Definition
  }

  class JmdictDoc < Nokogiri::XML::SAX::Document
    def initialize(each_entry_block)
      @each_entry_block = each_entry_block
      @current = nil
    end

    def start_document
    end

    def end_document
    end

    def start_element(name, attrs)
      parent = @current
      @current = (TAGS[name] || Tag::Other).new
      @current.start(name, attrs, parent)
    end

    def end_element(name)
      raise Eiwa::Error.new("Parsing error. Expected <#{@current.tag_name}> to close before <#{name}>") if @current.tag_name != name
      ending = @current
      ending.end_self
      if ending.is_a?(Tag::Entry)
        @each_entry_block&.call(ending)
      end

      @current = ending.parent
      @current&.end_child(ending)
    end

    def characters(s)
      @current.add_characters(s)
    end

    # def comment string
    #   puts "comment #{string}"
    # end

    # def warning string
    #   puts "warning #{string}"
    # end

    def error(msg)
      if (matches = msg.match(/Entity '(\S+)' not defined/))
        # See: http://github.com/sparklemotion/nokogiri/issues/1926
        code = matches[1]
        @current.set_entity(code, JMDICT_ENTITIES[code])
      elsif msg == "Detected an entity reference loop\n"
        # Do nothing and hope this does not matter.
      else
        raise Eiwa::Error.new("Parsing error: #{msg}")
      end
    end

    # def cdata_block string
    #   puts "cdata_block #{string}"
    # end

    # def processing_instruction name, content
    #   puts "processing_instruction #{name}, #{content}"
    # end
  end
end
