class MusicsController < ApplicationController
  def index
    @keyword = params[:music_search]
    @musics = Music.music_search(@keyword)
    @popular_musics = @musics.reorder(like_count: :desc)
    @new_musics = @musics.reorder(created_at: :desc)
  end
end
