ActiveAdmin.register Like do
  includes :user, :music
  filter :user
end
