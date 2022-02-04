require 'test_helper'

class UserMusicsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_musics_index_url
    assert_response :success
  end

  test "should get new" do
    get user_musics_new_url
    assert_response :success
  end

  test "should get create" do
    get user_musics_create_url
    assert_response :success
  end

  test "should get delete" do
    get user_musics_delete_url
    assert_response :success
  end

  test "should get edit" do
    get user_musics_edit_url
    assert_response :success
  end

  test "should get update" do
    get user_musics_update_url
    assert_response :success
  end

end
