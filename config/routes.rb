Rails.application.routes.draw do
  get 'home/my'
  get 'home/refresh_playlist'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :musics
  resources :user_musics
  resources :groups
  resources :group_musics
  resources :likes
  root 'home#index'
end
