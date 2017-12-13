Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/admin/sidekiq'

  resources :photos
  resources :cars
  resources :brands
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
