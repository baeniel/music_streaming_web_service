class HomeController < ApplicationController
  def index
    @keyword = Music.ransack(params[:keyword])
  end

  def my
    @love_musics = current_user.user_musics.love.order(created_at: :desc)
    @playlists = current_user.user_musics.playlist.order(created_at: :desc)
    @groups = current_user.groups
  end

  def refresh_playlist
    @playlists = current_user.user_musics.playlist.order(created_at: :desc)
    @sort_condition = "playlist"
  end
end
