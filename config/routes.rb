Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post 'signup', to: 'users#signup'
  post 'login', to: 'users#login'
  get 'profile', to: 'users#profile'
  patch 'update', to: 'users#update'
  post 'verify_email', to: 'users#verify_email'

  resources :event_dates do
    resources :user_events do
      resources :event_reminders
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
