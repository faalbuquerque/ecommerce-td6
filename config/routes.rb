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
    resources :orders, only: %i[index show] do
      resources :returns, only: %i[index] do
        post 'return_product', on: :collection
      end
    end
    resources :addresses, only: %i[index new create]
  end

end
