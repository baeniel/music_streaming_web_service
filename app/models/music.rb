class Music < ApplicationRecord
  has_many :user_musics, dependent: :nullify
  has_many :likes, dependent: :nullify
  has_many :group_musics, dependent: :nullify

  include PgSearch::Model
  pg_search_scope :music_search,
    against: {
      title: 'A',
      album_name: 'B',
      artist_name: 'C'
    },
    using: {
      tsearch: { prefix: true, dictionary: 'simple', tsvector_column: 'searchable' }
    }
  # scope :force_index, ->(index) { from("#{table_name} FORCE INDEX(#{index})") }
end
