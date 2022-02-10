class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_musics, except: [:show]
  before_action :load_object, only: [:show, :destroy]

  def index
    @groups = current_user&.groups
  end

  def new ;end

  def show ;end

  def create
    @group = Group.create(group_params)
    UserGroup.create(user: current_user, group: @group)
    music_ids = @music_ids.split(" ")
    if music_ids.any?
      add_playlists(music_ids, @group.id)
    end
  end

  def destroy
    @group.destroy
  end

  private

  def group_params
    params.require(:group).permit(:title, :intro, :image)
  end

  def find_musics
    @music_ids = params[:music_ids]
  end

  def load_object
    @group = Group.find params[:id]
  end
end
