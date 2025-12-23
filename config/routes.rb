Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Health check endpoint for testing authentication
  get "health" => "health#check"

  # Parking routes
  post "/parking", to: "parkings#create"
  get "/parking/:id", to: "parkings#show"
  put "/parking/:id/out", to: "parkings#out"
  put "/parking/:id/pay", to: "parkings#pay"

  # Defines the root path route ("/")
  # root "posts#index"
end
