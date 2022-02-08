class GroupMusicsController < ApplicationController
  def create
    music_ids = params[:music_ids]
    group_id = params[:group_id]
    add_playlists(music_ids, group_id)
  end

  def destroy
    music_ids = params[:music_ids]
    group_id = params[:group_id]
    @group = Group.find group_id
    # n개 삭제
    if music_ids.length > 1
      DestroyGroupPlaylistRecordsJob.perform_async(music_ids, @group.id)
    # 1개 삭제
    else
      music = Music.find music_ids.join(",")
      @group&.group_musics&.where(music: music)&.order(created_at: :desc)&.first&.destroy
    end
  end
end
