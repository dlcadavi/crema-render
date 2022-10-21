require "application_system_test_case"

class GuestsTest < ApplicationSystemTestCase
  setup do
    @guest = guests(:one)
  end

  test "visiting the index" do
    visit guests_url
    assert_selector "h1", text: "Guests"
  end

  test "should create guest" do
    visit guests_url
    click_on "New guest"

    fill_in "Annualfee", with: @guest.annualfee
    fill_in "Birthdate", with: @guest.birthdate
    fill_in "Country of birth", with: @guest.country_of_birth
    fill_in "Email", with: @guest.email
    fill_in "Fee", with: @guest.fee
    fill_in "Gender", with: @guest.gender
    fill_in "Hosting end date", with: @guest.hosting_end_date
    fill_in "Hosting start date", with: @guest.hosting_start_date
    fill_in "Id number", with: @guest.id_number
    fill_in "Lastname", with: @guest.lastname
    fill_in "Months", with: @guest.months
    fill_in "Name", with: @guest.name
    fill_in "Phone number", with: @guest.phone_number
    fill_in "University", with: @guest.university
    click_on "Create Guest"

    assert_text "Guest was successfully created"
    click_on "Back"
  end

  test "should update Guest" do
    visit guest_url(@guest)
    click_on "Edit this guest", match: :first

    fill_in "Annualfee", with: @guest.annualfee
    fill_in "Birthdate", with: @guest.birthdate
    fill_in "Country of birth", with: @guest.country_of_birth
    fill_in "Email", with: @guest.email
    fill_in "Fee", with: @guest.fee
    fill_in "Gender", with: @guest.gender
    fill_in "Hosting end date", with: @guest.hosting_end_date
    fill_in "Hosting start date", with: @guest.hosting_start_date
    fill_in "Id number", with: @guest.id_number
    fill_in "Lastname", with: @guest.lastname
    fill_in "Months", with: @guest.months
    fill_in "Name", with: @guest.name
    fill_in "Phone number", with: @guest.phone_number
    fill_in "University", with: @guest.university
    click_on "Update Guest"

    assert_text "Guest was successfully updated"
    click_on "Back"
  end

  test "should destroy Guest" do
    visit guest_url(@guest)
    click_on "Destroy this guest", match: :first

    assert_text "Guest was successfully destroyed"
  end
end
