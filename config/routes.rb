Rails.application.routes.draw do
  get 'home/search' => 'home#search'
  get 'shops/index' => 'shops#index'
  root 'home#top'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
