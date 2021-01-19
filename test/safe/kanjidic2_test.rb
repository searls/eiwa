require "test_helper"

class Kanjidic2Test < Minitest::Test
  def test_blockless_returns_array_and_blockfull_returns_nil
    result = Eiwa.parse_file("test/fixture/kanjidic2.xml", type: :kanjidic2)

    a = result.first
    assert_equal "亜", a.text
    assert_equal ["ア"], a.onyomi
    assert_equal ["つ.ぐ"], a.kunyomi
    assert_equal ["Asia", "rank next", "come after", "-ous"], a.meanings
    assert_equal 1, a.jlpt
    assert_equal 8, a.grade
    assert_equal 1509, a.freq
    assert_equal 7, a.stroke_count
  end
end
