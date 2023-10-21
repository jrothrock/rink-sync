Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :songs

  get "/skip_song", to: "home#skip_song"
  get "/new_game", to: "home#new_game"

  get 'views/javascript/:module/:file', to: 'assets#javascript', as: 'javascript_asset', format: 'js'
end
