require "open3"
require "test_helper"

class AnyTest < Minitest::Test
  def test_accumulates_characters_when_string_literals_are_frozen
    script = <<~RUBY
      require "eiwa"

      tag = Eiwa::Tag::Any.new
      tag.add_characters("日")
      tag.add_characters("本")

      abort unless tag.characters == "日本"
    RUBY

    _stdout, stderr, status = Open3.capture3(
      RbConfig.ruby,
      "--enable-frozen-string-literal",
      "-Ilib",
      "-e",
      script,
      chdir: File.expand_path("../..", __dir__)
    )

    assert status.success?, stderr
  end
end
