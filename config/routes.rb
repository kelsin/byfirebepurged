Rails.application.routes.draw do
  # Permissions
  concern :permissioned do
    resources :permissions
  end

  scope :defaults => { :format => 'json' } do
    # Raids
    resources :raids, :concerns => :permissioned do
      resources :signups
    end

    # Account
    resource :account

    # Sessions
    get '/login', to: 'sessions#new', :as => :login
    get '/logout', to: 'sessions#destroy', :as => :logout
    get '/auth/:provider/callback', :to => 'sessions#create'
    get '/auth/bnet', :as => :bnet
    root 'sessions#index'
  end
end
