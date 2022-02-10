class AddSearchableToMusics < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE musics
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('simple', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('simple', coalesce(album_name,'')), 'B') ||
        setweight(to_tsvector('simple', coalesce(artist_name,'')), 'C')
      ) STORED;
    SQL
  end

  def down
    remove_column :musics, :searchable
  end
end
