require "application_system_test_case"

class AcyearsTest < ApplicationSystemTestCase
  setup do
    @acyear = acyears(:one)
  end

  test "visiting the index" do
    visit acyears_url
    assert_selector "h1", text: "Acyears"
  end

  test "should create acyear" do
    visit acyears_url
    click_on "New acyear"

    fill_in "Finaldate", with: @acyear.finaldate
    fill_in "Name", with: @acyear.name
    fill_in "Startdate", with: @acyear.startdate
    click_on "Create Acyear"

    assert_text "Acyear was successfully created"
    click_on "Back"
  end

  test "should update Acyear" do
    visit acyear_url(@acyear)
    click_on "Edit this acyear", match: :first

    fill_in "Finaldate", with: @acyear.finaldate
    fill_in "Name", with: @acyear.name
    fill_in "Startdate", with: @acyear.startdate
    click_on "Update Acyear"

    assert_text "Acyear was successfully updated"
    click_on "Back"
  end

  test "should destroy Acyear" do
    visit acyear_url(@acyear)
    click_on "Destroy this acyear", match: :first

    assert_text "Acyear was successfully destroyed"
  end
end
