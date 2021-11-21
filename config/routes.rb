Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home" 
    get "/home", to: "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
    resources :microposts, only: %i(create destroy)
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :relationships, only: %i(create destroy)
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete  "/logout", to: "sessions#destroy"
  end
end
