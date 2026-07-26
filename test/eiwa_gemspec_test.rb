require "test_helper"

class EiwaGemspecTest < Minitest::Test
  def test_requires_a_ruby_version_supported_by_nokogiri
    refute gemspec.required_ruby_version.satisfied_by?(Gem::Version.new("3.1.7"))
    assert gemspec.required_ruby_version.satisfied_by?(Gem::Version.new("3.2.0"))
  end

  def test_requires_a_secure_nokogiri_release
    nokogiri_requirement = gemspec.runtime_dependencies
      .find { |dependency| dependency.name == "nokogiri" }
      .requirement

    refute nokogiri_requirement.satisfied_by?(Gem::Version.new("1.19.3"))
    assert nokogiri_requirement.satisfied_by?(Gem::Version.new("1.19.4"))
    assert nokogiri_requirement.satisfied_by?(Gem::Version.new("1.20.0"))
    refute nokogiri_requirement.satisfied_by?(Gem::Version.new("2.0.0"))
  end

  private

  def gemspec
    Gem::Specification.load(File.expand_path("../eiwa.gemspec", __dir__))
  end
end
