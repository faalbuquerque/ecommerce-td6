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

  get '/admin', to: 'admin/home#index', as: 'admin_root'
  namespace :admin do
    resources :registration_admins, only: %i[ new create index ]
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
