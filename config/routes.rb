Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  resources :products, only: %i[show] do
    resources :shippings, only: %i[index]
  end
  namespace :users do
    resources :carts, only: %i[index show create] do
      get 'my_orders', on: :collection
      get 'order', on: :member
    end
  end

  get '/admin', to: 'admin/home#index', as: 'admin_root'

  get '/search', to:"home#search"

  namespace :admin do
    resources :registration_admins, only: %i[ new create index ]
    resources :products, only: %i[index new create show edit update]
    resources :categories, only: %i[index new create show edit update]
  end

  namespace :user do
    get '/profile', to: 'profile#index'
    resources :addresses, only: %i[index new create]
  end

end
