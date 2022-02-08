class DestroyGroupPlaylistRecordsJob
  include Sidekiq::Job

  def perform(music_ids, group_id)
    group = Group.find group_id
    music_ids.each do |music_id|
      music = Music.find music_id
      group&.group_musics&.where(music: music)&.order(created_at: :desc)&.first&.destroy
    end
  end
end
