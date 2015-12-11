Rails.application.routes.draw do
  root to: 'static_pages#home'
  get 'signup',  to: 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get 'static_pages/adminpage'
  get 'static_pages/help'

  get 'badgeposts/recepting'
  get 'badgeposts/sending'
  get 'users/full_index'
  
  get '/reset_password', to: "reset_password#new"
  resources :reset_password, only: [:create]
  get "/update_password/:reset_password_token", to: "update_password#new", as: "update_password"
  resources :update_password, only: [:create]
  get "/invalid_token", to: "invalid_token#index"
	get "/reset_password_confirmation", to: "reset_password_confirmation#index"

  resources :users
  resources :bumons
  resources :sessions, only: [:new, :create, :destroy]
  resources :badges
  resources :badgeposts
  
end
