Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  get '/admin', to: 'admin/home#index', as: 'admin_root'
  namespace :admin do
    resources :registration_admins, only: %i[ new create index ]
    resources :products, only: %i[index new create show edit update]
    resources :categories, only: %i[index new create show edit update]
  end
  namespace :user do
    get '/profile', to: 'profile#index'
    resources :orders, only: %i[index]
    resources :addresses, only: %i[index new create]
  end
  root 'home#index'
end
