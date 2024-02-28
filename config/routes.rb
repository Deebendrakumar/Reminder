Rails.application.routes.draw do
  get 'welcome/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post 'signup', to: 'users#signup'
  post 'login', to: 'users#login'
  get 'profile', to: 'users#profile'
  patch 'update', to: 'users#update'
  post 'verify_email', to: 'users#verify_email'
  get 'password_reset_link', to: 'users#password_reset_link'
  post 'reset_password', to: 'users#reset_password'
  
    resources :user_events do
      collection do
        get 'search'
      end
      resources :event_reminders do
        collection do
          get 'search'
        end
      end
    end
  delete 'delete', to: 'users#delete'
  # Defines the root path route ("/")
  # root "posts#index"
end
