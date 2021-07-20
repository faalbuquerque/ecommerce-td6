Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  get '/admin', to: 'admin/home#index', as: 'admin_root'

  namespace :admin do
    resources :registration_admins, only: %i[ new create index ]
    resources :products, only: %i[index new create show edit update]
  end

  namespace :user do
    get '/profile', to: 'profile#index'
    resources :addresses, only: %i[index new create show edit update]
  end

  #root 'admin/home#index'
  root 'home#index'
end
