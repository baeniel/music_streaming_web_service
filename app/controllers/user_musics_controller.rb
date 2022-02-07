class UserMusicsController < ApplicationController
  before_action :authenticate_user!, :find_sort_condition, only: [:create, :destroy]
  before_action :find_user_musics, only: [:index, :destroy_playlist]

  def index ;end

  # 좋아요
  def create
    @music = Music.find params[:music]
    current_user.user_musics.create(music: @music, music_type: 1)
  end

  # 좋아요 삭제
  def destroy
    @music = Music.find params[:id]
    current_user.user_musics.find_by(music: @music, music_type: 1).destroy
  end

  # 재생목록 추가
  def add_playlist
    music_ids = params[:music]
    @sort_condition = params[:sort_condition]
    # n개 추가
    if music_ids.length > 1
      AddPlaylistRecordsJob.perform_async(music_ids, current_user.email)
    # 1개 추가
    else
      music = Music.find music_ids.join(",")
      current_user.user_musics.create(music: music, music_type: 0)
      CheckPlaylistRecordsJob.perform_async(current_user.email)
    end
  end

  # 재생목록 삭제
  def destroy_playlist
    music_ids = params[:music]
    # n개 추가
    if music_ids.length > 1
      DestroyPlaylistRecordsJob.perform_async(music_ids, current_user.email)
    # 1개 추가
    else
      music = Music.find music_ids.join(",")
      current_user&.user_musics&.where(music: music, music_type: 0)&.order(created_at: :desc)&.first&.destroy
    end
  end

  private

  def find_user_musics
    @user_musics = current_user.user_musics.where(music_type: 0).order(created_at: :desc)
  end

  def find_sort_condition
    @sort_condition = params[:sort_condition]
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
