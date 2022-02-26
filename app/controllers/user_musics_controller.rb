class UserMusicsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_musics, only: [:create, :destroy]

  def index
    @user_musics = current_user.user_musics.order(created_at: :desc)
  end

  # 재생목록 추가
  def create
    @sort_condition = params[:sort_condition]
    # n개 추가
    if @music_ids.length > 1
      AddPlaylistRecordsJob.perform_async(@music_ids, current_user.email)
    # 1개 추가
    else
      music = Music.find @music_ids.join(",")
      current_user.user_musics.create(music: music)
      CheckPlaylistRecordsJob.perform_async(current_user.email)
    end
  end

  # 재생목록 삭제
  def destroy
    # n개 삭제
    if @music_ids.length > 1
      DestroyPlaylistRecordsJob.perform_async(@music_ids, current_user.email)
    # 1개 삭제
    else
      music = Music.find @music_ids.join(",")
      current_user.user_musics.where(music: music).order(created_at: :desc).first.destroy
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
