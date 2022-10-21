require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = students(:one)
    @update = {
      name: 'Loreem Impsum',
      id_number: '734Y',
      hosting_start_date: '2021/01/01',
      image_url: 'lorem.jpg',
    }
  end

  test "should get index" do
    get students_url
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    assert_difference("Student.count") do
#      post students_url, params: { student: { birthdate: @student.birthdate, city_of_birth: @student.city_of_birth, country_of_birth: @student.country_of_birth, hosting_end_date: @student.hosting_end_date, hosting_start_date: @student.hosting_start_date, id_number: @student.id_number, image_url: @student.image_url, name: @student.name, program_level: @student.program_level, program_name: @student.program_name } }
      post students_url, params: { student: @update }
    end

    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    #patch student_url(@student), params: { student: { birthdate: @student.birthdate, city_of_birth: @student.city_of_birth, country_of_birth: @student.country_of_birth, hosting_end_date: @student.hosting_end_date, hosting_start_date: @student.hosting_start_date, id_number: @student.id_number, image_url: @student.image_url, name: @student.name, program_level: @student.program_level, program_name: @student.program_name } }
    patch student_url(@student), params: { student: @update }
    assert_redirected_to student_url(@student)
  end

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end

    assert_redirected_to students_url
  end
end
