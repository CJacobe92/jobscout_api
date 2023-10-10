Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :admins
      resources :owners
      resources :job_histories
      resources :applicants
      resources :tenants
      
      resources :employees
      resources :employers


      resources :jobs, only: [:index, :create, :update, :show, :destroy] do
        collection do
          get :tenant_index
        end
      end

      resources :auth, only: [] do
        collection do
          post :credentials
          post :password, param: :token, constraints: { token: /[^\/]+/ }
          get :refresh
        end
      end
    end
  end
end
