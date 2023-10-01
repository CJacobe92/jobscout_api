Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :admins
      resources :owners


      resources :auth, only: [] do
        collection do
          post :signin
        end
      end
    end
  end
end
