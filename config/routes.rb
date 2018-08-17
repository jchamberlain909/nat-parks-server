Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :parks, only: [:index, :show]
  resources :states, only: [:index, :show]
  get '/login', to: 'auth#login'
  
end
