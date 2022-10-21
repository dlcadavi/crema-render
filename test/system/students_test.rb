require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase
  setup do
    @student = students(:one)
  end

  test "visiting the index" do
    visit students_url
    assert_selector "h1", text: "Students"
  end

  test "should create student" do
    visit students_url
    click_on "New student"

    fill_in "Birthdate", with: @student.birthdate
    fill_in "City of birth", with: @student.city_of_birth
    fill_in "Country of birth", with: @student.country_of_birth
    fill_in "Hosting end date", with: @student.hosting_end_date
    fill_in "Hosting start date", with: @student.hosting_start_date
    fill_in "Id number", with: @student.id_number
    #fill_in "Image url", with: @student.image_url
    fill_in "Name", with: @student.name
    fill_in "Program level", with: @student.program_level
    fill_in "Program name", with: @student.program_name
    click_on "Create Student"

    assert_text "Student was successfully created"
    click_on "Back"
  end

  test "should update Student" do
    visit student_url(@student)
    click_on "Edit this student", match: :first

    fill_in "Birthdate", with: @student.birthdate
    fill_in "City of birth", with: @student.city_of_birth
    fill_in "Country of birth", with: @student.country_of_birth
    fill_in "Hosting end date", with: @student.hosting_end_date
    fill_in "Hosting start date", with: @student.hosting_start_date
    fill_in "Id number", with: @student.id_number
    #fill_in "Image url", with: @student.image_url
    fill_in "Name", with: @student.name
    fill_in "Program level", with: @student.program_level
    fill_in "Program name", with: @student.program_name
    click_on "Update Student"

    assert_text "Student was successfully updated"
    click_on "Back"
  end

  test "should destroy Student" do
    visit student_url(@student)
    click_on "Destroy this student", match: :first

    assert_text "Student was successfully destroyed"
  end
end
