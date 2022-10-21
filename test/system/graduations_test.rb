require "application_system_test_case"

class GraduationsTest < ApplicationSystemTestCase
  setup do
    @graduation = graduations(:one)
  end

  test "visiting the index" do
    visit graduations_url
    assert_selector "h1", text: "Graduations"
  end

  test "should create graduation" do
    visit graduations_url
    click_on "New graduation"

    click_on "Create Graduation"

    assert_text "Graduation was successfully created"
    click_on "Back"
  end

  test "should update Graduation" do
    visit graduation_url(@graduation)
    click_on "Edit this graduation", match: :first

    click_on "Update Graduation"

    assert_text "Graduation was successfully updated"
    click_on "Back"
  end

  test "should destroy Graduation" do
    visit graduation_url(@graduation)
    click_on "Destroy this graduation", match: :first

    assert_text "Graduation was successfully destroyed"
  end
end
