Rails.application.routes.draw do

  # Json API Version
  constraints(lambda { |r| r.format == :jsonapi }) do
    scope :module => :jsonapi do
      jsonapi_resources :raids, :as => :jsonapi_raids
      jsonapi_resources :accounts, :as => :jsonapi_accounts
      jsonapi_resources :characters, :as => :jsonapi_characters
      jsonapi_resources :guilds, :as => :jsonapi_guilds
      jsonapi_resources :signups, :as => :jsonapi_signup
    end
  end

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
