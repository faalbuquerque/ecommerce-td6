Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  resources :products, only: %i[show] do
    resources :shippings, only: %i[index]
  end
  namespace :users do
    resources :carts, only: %i[index show create]
  end
  namespace :admin do
    resources :products, only: %i[index new create show edit update]
  end
end
