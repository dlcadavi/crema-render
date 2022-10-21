require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select 'nav.side_nav a', minimun: 4
    assert_select 'main ul.catalog li', 3
    assert_select 'h2', 'MyStringR'

    # Verifica que traiga un precio con un separador de miles y sin decimales
    # assert_select '.price', /\$[,\d]/

  end
end
