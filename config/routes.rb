Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  namespace :admin do
    resources :products, only: %i[index new create show edit update]
  end
  namespace :user do
    get '/profile', to: 'profile#index'
    resources :addresses, only: %i[index new create show edit update]
  end

end
