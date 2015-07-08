Rails.application.routes.draw do
  resources :beers, only: [:new, :create]
  resources :searches, only: [:new, :create]
  root to: 'beers#new'
end
