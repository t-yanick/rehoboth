require "application_system_test_case"

class LocalesTest < ApplicationSystemTestCase
  test "root shows English by default" do
    visit "/"
    assert_selector "h1", text: "From Asia to Africa, delivered with your trust."
  end

  test "/en shows English" do
    visit "/en"
    assert_selector "h1", text: "From Asia to Africa, delivered with your trust."
  end

  test "/fr shows French" do
    visit "/fr"
    assert_selector "h1", text: "De l'Asie à l'Afrique, livré avec votre confiance."
  end
end
