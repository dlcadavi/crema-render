require "test_helper"

class GuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guest = guests(:one)
  end

  test "should get index" do
    get guests_url
    assert_response :success
  end

  test "should get new" do
    get new_guest_url
    assert_response :success
  end

  test "should create guest" do
    assert_difference("Guest.count") do
      post guests_url, params: { guest: { annualfee: @guest.annualfee, birthdate: @guest.birthdate, country_of_birth: @guest.country_of_birth, email: @guest.email, fee: @guest.fee, gender: @guest.gender, hosting_end_date: @guest.hosting_end_date, hosting_start_date: @guest.hosting_start_date, id_number: @guest.id_number, lastname: @guest.lastname, months: @guest.months, name: @guest.name, phone_number: @guest.phone_number, university: @guest.university } }
    end

    assert_redirected_to guest_url(Guest.last)
  end

  test "should show guest" do
    get guest_url(@guest)
    assert_response :success
  end

  test "should get edit" do
    get edit_guest_url(@guest)
    assert_response :success
  end

  test "should update guest" do
    patch guest_url(@guest), params: { guest: { annualfee: @guest.annualfee, birthdate: @guest.birthdate, country_of_birth: @guest.country_of_birth, email: @guest.email, fee: @guest.fee, gender: @guest.gender, hosting_end_date: @guest.hosting_end_date, hosting_start_date: @guest.hosting_start_date, id_number: @guest.id_number, lastname: @guest.lastname, months: @guest.months, name: @guest.name, phone_number: @guest.phone_number, university: @guest.university } }
    assert_redirected_to guest_url(@guest)
  end

  test "should destroy guest" do
    assert_difference("Guest.count", -1) do
      delete guest_url(@guest)
    end

    assert_redirected_to guests_url
  end
end
