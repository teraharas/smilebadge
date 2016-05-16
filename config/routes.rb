Rails.application.routes.draw do
  root to: 'static_pages#home'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'signup',  to: 'users#new'
  get 'login_top' => 'static_pages#login_top'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  
  get    'adminpage'   => 'static_pages#adminpage'
  get    'help'   => 'static_pages#help'
  get    'ranking' => 'static_pages#ranking'
  get    'summary' => 'static_pages#summary'
  get    'summary_recept_badge_user' => 'static_pages#summary_recept_badge_user'
  get    'summary_value_send' => 'static_pages#summary_value_send'
  get    'summary_value_bumon_send' => 'static_pages#summary_value_bumon_send'

  get 'badgeposts/recepting'
  get 'badgeposts/sending'
  get 'badgeposts/sending_all'
  get 'users/full_index'

  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :bumons
  resources :sessions, only: [:new, :create, :destroy]
  resources :badges
  resources :badgeposts
  resources :mongons
end
