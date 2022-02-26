ActiveAdmin.register UserMusic do
  includes :user, :music
  filter :created_at
end
