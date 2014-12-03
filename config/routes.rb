Rails.application.routes.draw do
  # Permissions
  concern :permissioned do
    resources :permissions
  end

  # Raids
  resources :raids, :concerns => :permissioned do
    resources :signups
  end

  # Account
  resource :account

  # Sessions
  post '/login', to: 'sessions#new', :as => :login, :defaults => { :format => :json }
  get '/auth/:provider/callback', :to => 'sessions#create', :defaults => { :format => :json }
  get '/auth/bnet', :as => :bnet, :defaults => { :format => :json }
  root 'sessions#index', :defaults => { :format => :json }
end
