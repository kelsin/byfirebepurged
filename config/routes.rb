Rails.application.routes.draw do

  # Raids
  resources :raids do
    resources :signups
    resources :permissions
  end

  # Signups
  resources :signups

  # Permissions
  resources :permissions

  # Account
  resource :account

  # Sessions
  get '/login', to: 'sessions#new', :as => :login
  get '/logout', to: 'sessions#destroy', :as => :logout
  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/bnet', :as => :bnet
  root 'sessions#index'
end
