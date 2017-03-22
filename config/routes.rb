Rails.application.routes.draw do
  root to: 'home#index'
  get '/help', to:'home#help'
  get '/about', to:'home#about'
  get '/contact', to: 'home#contact'
  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
    collection do
      get :tigers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
