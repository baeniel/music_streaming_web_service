class MusicsController < ApplicationController
  def index
    @keyword = Music.ransack(params[:q])
    @musics = @keyword.result(distinct: true)
    @popular_musics = @musics.left_joins(:user_musics).group(:id).order('SUM(user_musics.music_type = 1) DESC')
    @new_musics = @musics.order(created_at: :desc)
  end
end
