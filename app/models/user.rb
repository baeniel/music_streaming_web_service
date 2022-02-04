class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_musics, dependent: :destroy
  has_many :musics, through: :user_musics

  def has_music_love?(music)
    self&.user_musics&.find_by(music_type: 1, music: music)&.present?
  end
end
