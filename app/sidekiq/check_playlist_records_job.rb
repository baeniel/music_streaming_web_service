class CheckPlaylistRecordsJob
  include Sidekiq::Job

  def perform(user_email)
    user = User.find_by(email: user_email)
    playlist_records = user.user_musics.playlist
    if playlist_records.count > 100
      playlist_records.limit(playlist_records.count - 100).order(:created_at).destroy_all
    end
  end
end
