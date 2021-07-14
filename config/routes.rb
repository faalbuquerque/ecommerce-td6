Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  root 'home#index'
  namespace :admin do
    resources :products, only: %i[index new create show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
