class CheckGroupPlaylistRecordsJob
  include Sidekiq::Job

  def perform(group_id)
    group = Group.find group_id
    playlist_records = GroupMusic.where(group: group)
    if playlist_records.count > 100
      playlist_records.limit(playlist_records.count - 100).order(:created_at).destroy_all
    end
  end
end
