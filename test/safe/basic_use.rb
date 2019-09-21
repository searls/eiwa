class BasicUse < Minitest::Test
  def test_basic_use_with_block
    entries = []
    result = Eiwa.parse_file("test/fixture/1.xml") { |entry|
      entries << entry
    }

    assert_equal entries, result
    okashi = entries[0]
    assert_equal 1001710, okashi.id
    assert_equal "お菓子", okashi.text
    assert_equal 2, okashi.spellings.size
    assert_equal "お菓子", okashi.spellings[0].text
    assert_equal [:ichi1], okashi.spellings[0].frequency_tags
    assert_equal "御菓子", okashi.spellings[1].text
    assert_equal [], okashi.spellings[1].frequency_tags
    assert_equal 1, okashi.readings.size
    assert_equal "おかし", okashi.readings[0].text
    assert_equal [:ichi1], okashi.readings[0].frequency_tags
    assert_equal 1, okashi.meanings.size
    assert_equal [:noun], okashi.meanings[0].parts_of_speech
    assert_equal ["confections", "sweets", "candy"], okashi.meanings[0].definitions
  end
end
