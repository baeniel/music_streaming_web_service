class UserMusic < ApplicationRecord
  belongs_to :user
  belongs_to :music, optional: true

  after_save :check_record_count

  private

  def check_record_count
    playlist_records = self.user.user_musics
    if playlist_records.count > 100
      playlist_records.limit(playlist_records.count - 100).order(:created_at).destroy_all
    end
  end
end
