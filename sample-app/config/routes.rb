Rails.application.routes.draw do
  namespace :api, format: 'json' do
    get 'sessions/new'
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
    resources :posts do
      collection do
        get :all, :mine
      end
      member do
        post 'like', to: 'likes#create'
        delete 'like', to: 'likes#destroy'
        post 'comments', to: 'comments#create'
        # delete 'comments', to: 'comments#destroy'
      end
    end
    resources :users
    resources :account_activations, only: [:edit]
    resources :password_resets,     only: %i[new create edit update]
    resources :posts, only: %i[index show create destroy]
  end
end
