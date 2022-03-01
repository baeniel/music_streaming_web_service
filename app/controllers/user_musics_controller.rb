class UserMusicsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_musics, only: [:create, :destroy]

  def index
    @user_musics = current_user.user_musics.order(created_at: :desc)
  end

  # 재생목록 추가
  def create
    @sort_condition = params[:sort_condition]
    @music_ids.each do |music_id|
      music = Music.find music_id
      current_user.user_musics.create(music: music)
    end
  end

  # 재생목록 삭제
  def destroy
    @music_ids.each do |music_id|
      music = Music.find music_id
      current_user.user_musics.where(music: music).order(created_at: :desc).destroy_all
    end
  end

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def find_musics
    @music_ids = params[:music_ids]
  end
end
