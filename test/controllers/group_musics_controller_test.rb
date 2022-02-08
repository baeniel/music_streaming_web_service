require 'test_helper'

class GroupMusicsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get group_musics_create_url
    assert_response :success
  end

  test "should get destroy" do
    get group_musics_destroy_url
    assert_response :success
  end

end
