Rails.application.routes.draw do
  get 'home/index'

  resources :tasks

  devise_for :users
  root to: "home#index"
end
