class CheckPlaylistRecordsJob
  include Sidekiq::Job

  def perform(user_email)
    user = User.find_by(email: user_email)
    playlist_records = user.user_musics.where(music_type: 0)
    if playlist_records.count > 30
      playlist_records.limit(playlist_records.count - 30).order(:created_at).destroy_all
    end
  end
end
