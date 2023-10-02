Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :admins
      resources :owners
      resources :jobs
      resources :job_histories
      resources :employers
      resources :employees
      resources :applicants

      resources :auth, only: [] do
        collection do
          post :signin
        end
      end
    end
  end
end
