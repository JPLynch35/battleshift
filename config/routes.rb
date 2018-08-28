Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :games, only: [:show] do
        post "/shots", to: "games/shots#create"
      end
    end
  end
  root 'welcome#index'
  get '/logout', to: 'sessions#destroy', as: 'logout'
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  get '/register', to: 'users#new', as: 'register'
  get '/verification', to: 'verification#show', as: 'verification'
  get '/dashboard', to: 'dashboard#show', as: 'dashboard'
  resources :users, only: [:create]
end
