ActiveAdmin.register Music do
  index do
    selectable_column
    id_column
    column :title
    column :artist_name
    column :album_name
    column :like_count
    column :created_at
    column :updated_at
    column :searchable
    actions
  end
end
