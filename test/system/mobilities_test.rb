require "application_system_test_case"

class MobilitiesTest < ApplicationSystemTestCase
  setup do
    @mobility = mobilities(:one)
  end

  test "visiting the index" do
    visit mobilities_url
    assert_selector "h1", text: "Mobilities"
  end

  test "should create mobility" do
    visit mobilities_url
    click_on "New mobility"

    click_on "Create Mobility"

    assert_text "Mobility was successfully created"
    click_on "Back"
  end

  test "should update Mobility" do
    visit mobility_url(@mobility)
    click_on "Edit this mobility", match: :first

    click_on "Update Mobility"

    assert_text "Mobility was successfully updated"
    click_on "Back"
  end

  test "should destroy Mobility" do
    visit mobility_url(@mobility)
    click_on "Destroy this mobility", match: :first

    assert_text "Mobility was successfully destroyed"
  end
end
