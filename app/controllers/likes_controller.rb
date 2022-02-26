class LikesController < ApplicationController
  before_action :authenticate_user!, :find_sort_condition

  def create
    @music = Music.find params[:music]
    current_user.likes.create(music: @music)
  end

  def destroy
    @music = Music.find params[:id]
    current_user.likes.find_by(music: @music).destroy
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
end
