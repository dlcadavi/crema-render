require "application_system_test_case"

class ProfessorsTest < ApplicationSystemTestCase
  setup do
    @professor = professors(:one)
  end

  test "visiting the index" do
    visit professors_url
    assert_selector "h1", text: "Professors"
  end

  test "should create professor" do
    visit professors_url
    click_on "New professor"

    fill_in "Email", with: @professor.email
    fill_in "Id number", with: @professor.id_number
    fill_in "Lastname", with: @professor.lastname
    fill_in "Name", with: @professor.name
    fill_in "Phone number", with: @professor.phone_number
    click_on "Create Professor"

    assert_text "Professor was successfully created"
    click_on "Back"
  end

  test "should update Professor" do
    visit professor_url(@professor)
    click_on "Edit this professor", match: :first

    fill_in "Email", with: @professor.email
    fill_in "Id number", with: @professor.id_number
    fill_in "Lastname", with: @professor.lastname
    fill_in "Name", with: @professor.name
    fill_in "Phone number", with: @professor.phone_number
    click_on "Update Professor"

    assert_text "Professor was successfully updated"
    click_on "Back"
  end

  test "should destroy Professor" do
    visit professor_url(@professor)
    click_on "Destroy this professor", match: :first

    assert_text "Professor was successfully destroyed"
  end
end
