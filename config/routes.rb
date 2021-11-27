Rails.application.routes.draw do
  root 'homes#top'
  get '/home/about' => 'homes#about'
  devise_for :users
  resources :users do
    member do
      get :following, :follower
    end
    resources :rooms, only: [:create, :show]
    get 'search' => 'users#search'
  end
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :groups, only: [:new, :create, :index, :show, :edit, :update] do
    member do
      get :join
      get :leave
      resources :inquiries, only: [:new, :create, :show]
    end
  end
  resources :messages, only: [:create]
  post 'follow/:id' => 'relationships#create', as: 'follow'
  post 'unfollow/:id' => 'relationships#destroy', as: 'unfollow'
  get 'search' => 'searches#search'

end