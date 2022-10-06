Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :authentication ,only: [] do
        collection do
          post :login
          post :sign_up
          post :create_car_details
          get :get_car_brands
          get :get_car_models
          get :get_car_profile
        end
      end

      resources :users

      resources :reset_passwords ,only: [] do
        collection do
          post :send_otp
          post :verify_otp
          post :resend_otp
          post :reset_password
        end
      end

      resources :social_logins , only: [] do
        collection do
          post :social_login
        end
      end

      resources :static_pages, param: :permalink ,only: [] do
        member do
          post :index
        end
      end
    end
  end

  get '/*a', to: 'api/v1/api#not_found'
end
