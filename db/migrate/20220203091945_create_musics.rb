class CreateMusics < ActiveRecord::Migration[6.0]
  def change
    create_table :musics do |t|
      t.string :title
      t.string :artist_name
      t.string :album_name
      t.string :image

      t.timestamps
    end
  end
end
