class AddLikeCountToMusics < ActiveRecord::Migration[6.0]
  def change
    add_column :musics, :like_count, :integer, default: 0
  end
end
