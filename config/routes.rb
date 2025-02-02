Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, controllers: { registrations: 'users/registrations' }
    get 'home/index'
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    root "home#index"

    resources :products, only: %i[index show new create destroy]

    resources :catalogs, only: %i[index] do
      collection do
        get '/catalog/:tab', to: 'catalog#index', as: :catalog
      end

      member do
        get :show
      end
    end

    resources :chat_rooms, only: %i[index create show update destroy] do
      resources :messages, only: [:create]
    end

    resources :favorite_products, only: %i[index create destroy]

    resources :wallets, only: [:index] do
      member do
        post :add_funds
      end
    end

    namespace :admin do
      resources :users, :products
    end
  end
end
