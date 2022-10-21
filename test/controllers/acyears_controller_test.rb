require "test_helper"

class AcyearsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @acyear = acyears(:one)
  end

  test "should get index" do
    get acyears_url
    assert_response :success
  end

  test "should get new" do
    get new_acyear_url
    assert_response :success
  end

  test "should create acyear" do
    assert_difference("Acyear.count") do
      post acyears_url, params: { acyear: { finaldate: @acyear.finaldate, name: @acyear.name, startdate: @acyear.startdate } }
    end

    assert_redirected_to acyear_url(Acyear.last)
  end

  test "should show acyear" do
    get acyear_url(@acyear)
    assert_response :success
  end

  test "should get edit" do
    get edit_acyear_url(@acyear)
    assert_response :success
  end

  test "should update acyear" do
    patch acyear_url(@acyear), params: { acyear: { finaldate: @acyear.finaldate, name: @acyear.name, startdate: @acyear.startdate } }
    assert_redirected_to acyear_url(@acyear)
  end

  test "should destroy acyear" do
    assert_difference("Acyear.count", -1) do
      delete acyear_url(@acyear)
    end

    assert_redirected_to acyears_url
  end
end
