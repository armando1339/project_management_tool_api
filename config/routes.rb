Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  use_doorkeeper

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      resources :projects do
        resources :tasks do
          member do
            post :assign_user
            delete :unassign_user
          end
        end
      end

      resources :github, only: [] do
        collection do
          get :latest_public_repositories
        end
      end
    end
  end
end
