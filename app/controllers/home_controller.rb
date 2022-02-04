class HomeController < ApplicationController
  def index
    @keyword = Music.ransack(params[:keyword])
  end
end
