class UserMusicsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    @music = Music.find params[:music]
    current_user.user_musics.create(music: @music, music_type: 1)
  end

  def destroy
    @music = Music.find params[:id]
    current_user.user_musics.find_by(music: @music, music_type: 1).destroy
  end

  def edit
  end

  def update
  end

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
