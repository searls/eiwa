require "test_helper"

class JmdictETest < Minitest::Test
  def test_entity_error_limit
    entry = Eiwa.parse_file("test/fixture/jmdict_e_entity_limit.xml").find { |e|
      e.id == 1224880
    }

    assert_equal "adj-i", entry.meanings.first.parts_of_speech.first.code
  end
end
