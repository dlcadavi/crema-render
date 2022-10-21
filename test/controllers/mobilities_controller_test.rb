require "test_helper"

class MobilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mobility = mobilities(:one)
  end

  test "should get index" do
    get mobilities_url
    assert_response :success
  end

  test "should get new" do
    get new_mobility_url
    assert_response :success
  end

  test "should create mobility" do
    assert_difference("Mobility.count") do
      post mobilities_url, params: { mobility: {  } }
    end

    assert_redirected_to mobility_url(Mobility.last)
  end

  test "should show mobility" do
    get mobility_url(@mobility)
    assert_response :success
  end

  test "should get edit" do
    get edit_mobility_url(@mobility)
    assert_response :success
  end

  test "should update mobility" do
    patch mobility_url(@mobility), params: { mobility: {  } }
    assert_redirected_to mobility_url(@mobility)
  end

  test "should destroy mobility" do
    assert_difference("Mobility.count", -1) do
      delete mobility_url(@mobility)
    end

    assert_redirected_to mobilities_url
  end
end
