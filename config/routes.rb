Rails.application.routes.draw do
  root 'homes#top'
  get '/home/about' => 'homes#about'
  devise_for :users
  resources :users do
    member do
      get :follow, :unfollow
    end
  end
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  post 'follow/:id' => 'relationships#follow', as: 'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'

end