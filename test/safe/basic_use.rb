class BasicUse < Minitest::Test
  def test_blockless_returns_array_and_blockfull_returns_nil
    result = Eiwa.parse_file("test/fixture/1.xml")
    block_entries = []
    will_be_nil = Eiwa.parse_file("test/fixture/1.xml") { |e|
      block_entries << e
    }

    assert_nil will_be_nil
    assert_equal result.map(&:id), block_entries.map(&:id)
  end

  def test_the_first_word
    entries = Eiwa.parse_file("test/fixture/1.xml", type: :jmdict_e)

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
    assert_equal 1, okashi.meanings[0].parts_of_speech.size
    assert_equal [entity("n")], okashi.meanings[0].parts_of_speech
    assert_equal [
      gloss(text: "confections"),
      gloss(text: "sweets"),
      gloss(text: "candy")
    ], okashi.meanings[0].definitions
  end

  def test_word_with_ke_inf_and_misc_tags
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1000225 }

    assert_equal "明白", entry.text
    assert_equal 3, entry.spellings.size
    assert_equal "明白", entry.spellings[0].text
    assert_equal [entity("ateji")], entry.spellings[0].info_tags
    assert_equal "偸閑", entry.spellings[1].text
    assert_equal [entity("ateji")], entry.spellings[1].info_tags
    assert_equal "白地", entry.spellings[2].text
    assert_equal [entity("ateji")], entry.spellings[2].info_tags
    assert_equal 1, entry.readings.size
    assert_equal "あからさま", entry.readings[0].text
    assert_equal 1, entry.meanings.size
    assert_equal [
      entity("adj-na"), entity("adj-no")
    ], entry.meanings[0].parts_of_speech
    assert_equal [entity("uk")], entry.meanings[0].misc_tags
    assert_equal [
      "plain", "frank", "candid", "open", "direct", "straightforward",
      "unabashed", "blatant", "flagrant"
    ].map { |t| gloss(text: t) }, entry.meanings[0].definitions
  end

  def test_word_with_no_kanji_but_xref_and_pos_and_misc_trickle_down_and_stagr
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1067460 }

    assert_equal "スウェット", entry.text
    assert_empty entry.spellings
    assert_equal 3, entry.readings.size
    assert_equal "スウェット", entry.readings[0].text
    assert_equal "スエット", entry.readings[1].text
    assert_equal "スェット", entry.readings[2].text
    assert_equal 3, entry.meanings.size
    assert_equal [gloss(text: "sweat")], entry.meanings[0].definitions
    assert_equal [entity("n")], entry.meanings[0].parts_of_speech
    assert_equal [
      xref(text: "汗", sense_ordinal: 1)
    ], entry.meanings[0].cross_references
    assert_equal [], entry.meanings[0].misc_tags
    assert_equal [
      gloss(text: "sweatshirt"),
      gloss(text: "sweatpants")
    ], entry.meanings[1].definitions
    assert_equal [entity("n")], entry.meanings[1].parts_of_speech
    assert_equal [
      xref(text: "スウェットシャツ"),
      xref(text: "スウェットパンツ")
    ], entry.meanings[1].cross_references
    assert_equal [entity("abbr")], entry.meanings[1].misc_tags

    assert_equal [gloss(text: "suet")], entry.meanings[2].definitions
    assert_equal ["スエット"], entry.meanings[2].restricted_to_readings
    assert_equal [entity("n")], entry.meanings[2].parts_of_speech
    assert_equal [entity("abbr")], entry.meanings[2].misc_tags
  end

  def test_nokanji
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1001170 }

    assert_equal "斉魚", entry.text
    assert_equal 2, entry.readings.size
    assert_equal "えつ", entry.readings[0].text
    refute entry.readings[0].imprecise_reading?
    assert_equal "エツ", entry.readings[1].text
    assert entry.readings[1].imprecise_reading?
  end

  def test_re_inf
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 2840838 }

    assert_equal "黄牛", entry.text
    assert_equal 2, entry.readings.size
    assert_equal "あめうし", entry.readings[0].text
    assert_equal "あめうじ", entry.readings[1].text
    assert_equal [entity("ok")], entry.readings[1].info_tags
  end

  def test_stagk
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 2827931 }

    assert_equal "個食", entry.text
    assert_equal 3, entry.meanings.size
    assert_equal [
      gloss(text: "food sold in single servings")
    ], entry.meanings[2].definitions
    assert_equal ["個食", "こ食"], entry.meanings[2].restricted_to_spellings
  end

  def test_xref_edge_cases
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1000420 }

    assert_equal "彼の", entry.text
    assert_equal 1, entry.meanings.size
    assert_equal [
      gloss(text: "that (someone or something distant from both speaker and listener, or situation unfamiliar to both speaker and listener)")
    ], entry.meanings[0].definitions
    assert_equal [entity("adj-pn")], entry.meanings[0].parts_of_speech
    assert_equal [entity("uk")], entry.meanings[0].misc_tags
    assert_equal [
      xref(text: "何の", reading: "どの"),
      xref(text: "此の", sense_ordinal: 1),
      xref(text: "其の", sense_ordinal: 1),
      xref(text: "彼", reading: "あれ", sense_ordinal: 1)
    ], entry.meanings[0].cross_references
  end

  def test_antonyms
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1020710 }

    assert_equal "アンマウント", entry.text
    assert_equal 1, entry.meanings.size
    assert_equal [
      gloss(text: "unmounting (e.g. a drive)")
    ], entry.meanings[0].definitions
    assert_equal [entity("n"), entity("vs")], entry.meanings[0].parts_of_speech
    assert_equal [ant(text: "マウント")], entry.meanings[0].antonyms
    assert_equal [entity("comp")], entry.meanings[0].fields
  end

  def test_antonym_with_sense_restriction
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1014630 }

    assert_equal "アウター", entry.text
    assert_equal [ant(text: "インナー", sense_ordinal: 1)], entry.meanings[0].antonyms
  end

  def test_lsource
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1014660 }

    assert_equal "アウタルキー", entry.text
    assert_equal [lsource(text: "Autarkie", language: "ger")], entry.meanings[0].source_languages
  end

  def test_lsource_wasei
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1014670 }

    assert_equal "アウテリア", entry.text
    assert_equal [lsource(text: "outerior", wasei: true)], entry.meanings[0].source_languages
  end

  def test_lsource_type
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1053260 }

    assert_equal "コンビナートキャンペーン", entry.text
    assert_equal [
      lsource(text: "kombinat", language: "rus", type: "part"),
      lsource(text: "campaign", language: "eng", type: "part")
    ], entry.meanings[0].source_languages
  end

  def test_dialect_and_s_inf
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 1122910 }

    assert_equal "ホルモン", entry.text
    assert_equal [entity("ksb")], entry.meanings[1].dialects
    assert_equal ["from 放る物"], entry.meanings[1].comments
  end

  def test_gloss_g_type
    entry = Eiwa.parse_file("test/fixture/1.xml").find { |e| e.id == 2841394 }

    assert_equal "エスコートキッズ", entry.text
    assert_equal [
      gloss(text: "child mascots"),
      gloss(text: "player escorts"),
      gloss(text: "children who accompany soccer players entering the pitch", type: "expl")
    ], entry.meanings[0].definitions
    assert entry.meanings[0].definitions[2].explanation?
  end

  private

  def entity(code)
    Eiwa::Tag::Entity.new(code: code, text: Eiwa::JMDICT_ENTITIES[code])
  end

  def xref(options)
    Eiwa::Tag::CrossReference.new(options)
  end

  def ant(options)
    Eiwa::Tag::Antonym.new(options)
  end

  def lsource(options)
    Eiwa::Tag::SourceLanguage.new(options)
  end

  def gloss(options)
    Eiwa::Tag::Definition.new(options)
  end
end
