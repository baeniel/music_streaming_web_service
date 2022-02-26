class RemoveMusicTypeFromUserMusics < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_musics, :music_type, :integer
  end
end
