class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @music_ids = params[:music_ids]
    @groups = current_user.groups
  end

  def new
    @music_ids = params[:music_ids]
  end

  def show
    @group = Group.find params[:id]
  end

  def create
    music_ids = params[:music_ids].split(" ")
    group = Group.create(group_params)
    UserGroup.create(user: current_user, group: group)
    add_playlists(music_ids, group.id)
  end

  private

  def group_params
    params.require(:group).permit(:title, :intro, :image)
  end
end
