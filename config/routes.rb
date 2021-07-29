Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  resources :products, only: %i[show] do
    resources :shippings, only: %i[index] 
    get '/shippings_options', to: 'shippings#shippings_options'
  end
  namespace :users do
    resources :orders, only: %i[index show create]
    resources :products, only: %i[show] do
      resources :carts, only: %i[create]
    end
    resources :carts, only: %i[index show update] do
      get 'my_orders', on: :collection
      get 'order', on: :member
    end
  end

  get '/admin', to: 'admin/home#index', as: 'admin_root'

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
