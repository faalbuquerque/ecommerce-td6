Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  resources :products, only: %i[show]

  namespace :admin do
    resources :products, only: %i[index new create show edit update]
  end
end
