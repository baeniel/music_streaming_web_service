class Music < ApplicationRecord
  has_many :user_musics, dependent: :nullify
end
