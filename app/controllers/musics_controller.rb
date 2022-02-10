class MusicsController < ApplicationController
  def index
    @keyword = params[:music_search]
    @musics = Music.music_search(@keyword)
    @popular_musics = @musics.left_joins(:user_musics).group(:id).reorder('COUNT(user_musics.music_type = 1) DESC')
    @new_musics = @musics.reorder(created_at: :desc)
  end
end
