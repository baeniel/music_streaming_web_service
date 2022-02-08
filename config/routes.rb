Rails.application.routes.draw do
  root 'home#index'
  get 'home/my'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :musics
  resources :user_musics do
    collection do
      post :add_playlist
      delete :destroy_playlist
    end
  end
  resources :groups
  resources :group_musics
end
