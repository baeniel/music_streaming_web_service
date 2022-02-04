class MusicsController < ApplicationController
  def index
    @keyword = Music.ransack(params[:q])
    @musics = @keyword.result(distinct: true)
  end
end
