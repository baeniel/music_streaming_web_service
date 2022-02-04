class CreateUserMusics < ActiveRecord::Migration[6.0]
  def change
    create_table :user_musics do |t|
      t.references :user, null: false, foreign_key: true
      t.references :music, null: false, foreign_key: true
      t.integer :music_type, default: 0

      t.timestamps
    end
  end
end
