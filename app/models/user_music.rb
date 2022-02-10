class UserMusic < ApplicationRecord
  belongs_to :user
  belongs_to :music, optional: true, touch: true

  enum music_type: %i(playlist love)
end
