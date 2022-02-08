class UserMusicsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_sort_condition, only: [:create, :destroy]
  before_action :find_musics, only: [:add_playlist, :destroy_playlist]

  def index
    @user_musics = current_user.user_musics.playlist.order(created_at: :desc)
  end

  # 좋아요
  def create
    @music = Music.find params[:music]
    current_user.user_musics.love.create(music: @music)
  end

  # 좋아요 삭제
  def destroy
    @music = Music.find params[:id]
    current_user.user_musics.love.find_by(music: @music).destroy
  end

  # 재생목록 추가
  def add_playlist
    @sort_condition = params[:sort_condition]
    # n개 추가
    if @music_ids.length > 1
      AddPlaylistRecordsJob.perform_async(@music_ids, current_user.email)
    # 1개 추가
    else
      music = Music.find @music_ids.join(",")
      current_user.user_musics.playlist.create(music: music)
      CheckPlaylistRecordsJob.perform_async(current_user.email)
    end
  end

  # 재생목록 삭제
  def destroy_playlist
    # n개 삭제
    if @music_ids.length > 1
      DestroyPlaylistRecordsJob.perform_async(@music_ids, current_user.email)
    # 1개 삭제
    else
      music = Music.find @music_ids.join(",")
      current_user.user_musics.playlist.where(music: music).order(created_at: :desc).first.destroy
    end
  end

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def find_sort_condition
    @sort_condition = params[:sort_condition]
  end

  def find_musics
    @music_ids = params[:music_ids]
  end
end
