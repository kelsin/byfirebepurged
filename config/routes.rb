Rails.application.routes.draw do
  # Account
  resource :account

  # Sessions
  post '/login', to: 'sessions#new', :as => :login, :defaults => { :format => :json }
  get '/auth/:provider/callback', :to => 'sessions#create', :defaults => { :format => :json }
  get '/auth/bnet', :as => :bnet, :defaults => { :format => :json }
  root 'sessions#index', :defaults => { :format => :json }
end
