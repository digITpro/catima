require "test_helper"

class ExternalTypeTest < ActiveSupport::TestCase
  test "uses 5 minute cache by default" do
    ext = ExternalType.new("foo")

    assert_instance_of(ExternalType::ClientWithCache, ext.client)
    assert_equal(Rails.cache, ext.client.cache)
    assert_equal(1.hour, ext.client.options[:expires_in])
  end

  test "#valid?" do
    github_api = external_type("https://api.github.com/repos/rails/rails")
    github_html = external_type("https://github.com/")
    non_existent = external_type("http://vss.naxio.ch/does-not-exist")

    assert(vss.valid?)
    refute(github_api.valid?)
    refute(github_html.valid?)
    refute(non_existent.valid?)
  end

  test "#name" do
    assert_equal("Keyword", vss.name)
    assert_equal("Keyword", vss.name(:en))
    assert_equal("Schlüsselwort", vss.name(:de))
    assert_equal("Mot-clé", vss.name(:fr))
  end

  test "#locales" do
    assert_equal(%w(fr de en), vss.locales)
  end

  test "#find_item" do
    item = vss.find_item("25-pretty-id") # should be interpreted as 25

    assert_equal(25, item.id)
    assert_equal("Wolken", item.name(:de))
    assert_equal("Clouds", item.name(:en))
    assert_equal("nuages", item.name(:fr))
  end

  test "#find_item raises for non-existent ID" do
    assert_raises(ExternalType::Client::NotFound) do
      vss.find_item("99999999")
    end
  end

  test "#all_items" do
    items = vss.all_items

    assert_instance_of(Array, items)
    refute_empty(items)
    merch = items.find { |i| i.name(:en) == "Merchandise" }
    refute_nil(merch.id)
    assert_equal("Ware", merch.name(:de))
    assert_equal("marchandises", merch.name(:fr))
  end

  private

  def vss
    external_type("http://vss.naxio.ch/keywords/default/api/v1")
  end

  def external_type(url)
    ExternalType.new(url, :client => ExternalType::Client.new)
  end
end
