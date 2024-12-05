Rails.application.routes.draw do
  namespace :api, format: 'json' do
    get 'sessions/new'
    # root 'static_pages#home'
    # get  '/help',    to: 'static_pages#help'
    # get  '/about',   to: 'static_pages#about'
    # get  '/contact', to: 'static_pages#contact'
    get '/signup', to: 'users#new'
    # get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'
    resources :users do
      member do
        get :followees, :followers
        post '/follow', to: 'follow_users#create'
        delete '/follow', to: 'follow_users#destroy'
      end
    end
    resources :users
    resources :account_activations, only: [:edit]
    resources :password_resets,     only: %i[new create edit update]
    resources :posts, only: %i[index show create destroy]
    # resources :follow_users, only: %i[create destroy]
  end
end
