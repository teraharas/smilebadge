Rails.application.routes.draw do
  root to: 'static_pages#home'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'signup',  to: 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  
  get    'adminpage'   => 'static_pages#adminpage'
  get    'help'   => 'static_pages#help'
  get    'summary' => 'static_pages#summary'
  get    'ranking' => 'static_pages#ranking'

  get 'badgeposts/recepting'
  get 'badgeposts/sending'
  get 'users/full_index'

  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :bumons
  resources :sessions, only: [:new, :create, :destroy]
  resources :badges
  resources :badgeposts
  resources :mongons
end
