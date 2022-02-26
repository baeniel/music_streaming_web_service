class Like < ApplicationRecord
  belongs_to :user
  belongs_to :music

  after_save :add_music_love
  after_destroy :destroy_music_love

  private

  def add_music_love
    self.music.increment!(:like_count)
  end

  def destroy_music_love
    music = self.music
    if music.like_count >= 1
      music.decrement!(:like_count)
    end
  end
end
