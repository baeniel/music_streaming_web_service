class AddGroupPlaylistRecordsJob
  include Sidekiq::Job

  def perform(music_ids, user_email, group_id)
    user = User.find_by(email: user_email)
    group = Group.find group_id
    music_ids.each do |music_id|
      music = Music.find music_id
      GroupMusic.create(user: user, group: group, music: music)
      CheckGroupPlaylistRecordsJob.perform_async(group.id)
    end
  end
end
