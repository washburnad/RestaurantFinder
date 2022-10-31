Rails.application.routes.draw do
  devise_for :users

  resources :search, only: :create
  resources :favorites, only: :create 

  namespace :favorites do
    delete ':place_id', action: 'destroy'
  end
end
