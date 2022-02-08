class HomeController < ApplicationController
  def index
    @keyword = Music.ransack(params[:keyword])
  end

  def my
    @love_musics = UserMusic.love.where(user: current_user).order(created_at: :desc)
    @playlists = UserMusic.playlist.where(user: current_user).order(created_at: :desc)
    @groups = current_user.groups
  end
end
