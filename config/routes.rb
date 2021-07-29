Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  resources :products, only: %i[show] do
    resources :shippings, only: %i[index] 
    get '/shippings_options', to: 'shippings#shippings_options'
  end
  namespace :users do
    resources :products, only: %i[show] do
      resources :carts, only: %i[create]
    end
    resources :evaluations, only: %i[create edit update]
    resources :carts, only: %i[index show update] do
      get 'my_orders', on: :collection
      get 'order', on: :member
    end
  end

  get '/admin', to: 'admin/home#index', as: 'admin_root'

  get '/search', to:"home#search"

  namespace :admin do
    resources :registration_admins, only: %i[ new create index]
    resources :products, only: %i[index new create show edit update]
    resources :categories, only: %i[index new create show edit update]
  end
  namespace :user do
    get '/profile', to: 'profile#index'
    resources :returns, only: %i[index]
    resources :carts, only: %i[index show] do
      post 'return_product', to: 'returns#return_product' , on: :member
    end
    resources :addresses, only: %i[index new create]
  end

end
