require 'test_helper'

class MusicsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get musics_index_url
    assert_response :success
  end

  test "should get show" do
    get musics_show_url
    assert_response :success
  end

end
