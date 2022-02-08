class Group < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups

  has_many :group_musics, dependent: :destroy
  has_many :musics, through: :group_musics
end
