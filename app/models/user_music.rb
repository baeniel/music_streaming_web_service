class UserMusic < ApplicationRecord
  belongs_to :user
  belongs_to :music, optional: true

  enum music_type: %i(재생목록 좋아요)
end
