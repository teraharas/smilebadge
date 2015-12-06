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

  resources :users
  resources :bumons
  resources :sessions, only: [:new, :create, :destroy]
  resources :badges
  resources :badgeposts
end
