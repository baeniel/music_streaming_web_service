class HomeController < ApplicationController
  def index ;end

  def my
    @love_musics = current_user.likes.order(created_at: :desc)
    @playlists = current_user.user_musics.order(created_at: :desc)
    @groups = current_user.groups
  end

  def refresh_playlist
    @playlists = current_user.user_musics.order(created_at: :desc)
    @sort_condition = "playlist"
  end
end
