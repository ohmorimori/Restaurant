Rails.application.routes.draw do
  root 'home#top'
  get 'shops/index' => 'shops#index'
   
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  get 'login' => 'users#login_form'
  post 'login' => 'users#login'
  post 'logout' => 'users#logout'

  post 'bookmarks/:shop_id/create' => 'bookmarks#create'
  delete 'bookmarks/:shop_id/destroy' => 'bookmarks#destroy'
  get 'bookmarks/index' => 'bookmarks#index'

  resources :users, only: [:show, :edit, :update, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
