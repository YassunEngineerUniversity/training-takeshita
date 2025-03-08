Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  namespace :api, format: 'json' do
    get 'sessions/new'
    get '/signup', to: 'users#new'
    get    '/login',   to: 'sessions#index'
    post   '/login',   to: 'sessions#create'
    delete '/login', to: 'sessions#destroy'
    resources :users
    resources :account_activations, only: [:edit]
    resources :password_resets,     only: %i[create update]
    resources :reservations, only: %i[index]
    resources :tickets, only: %i[index]
    
    namespace :admin do
      get    '/login',   to: 'sessions#index'
      post   '/login',   to: 'sessions#create'
      delete '/login', to: 'sessions#destroy'
      resources :tickets do
        member do
          post :use
          post :transfer
        end
        resources :perks do
          member do
            post :use
          end 
        end
      end
      resources :users, only: %i[index show update destroy]
      resources :reservations, only: %i[index show update destroy]
      resources :tickets, only: %i[index show update destroy]
      resources :perks, only: %i[index show update destroy]
      resources :events, only: %i[index show update destroy]
    end
  end
end
