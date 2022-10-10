Rails.application.routes.draw do
  root to: "admins/dashboard#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :authentication ,only: [] do
        collection do
          post :login
          post :sign_up
          post :create_car_profile
          post :update_car_profile
          get :get_car_specification
          get :get_car_profile
        end
      end

      resources :users ,only: [] do
        collection do
          get :get_user
          post :update_user
        end
      end

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

      resources :quick_chats , only: [] do
        member do
          post :delete_quick_chat
        end
        collection do
          get :get_all_quick_chat
          post :create_quick_chat
          post :update_quick_chat
        end
      end
    end
  end
  
  namespace :admins do
    resources :dashboard, only: [] do
      collection do
        get :index
      end
    end
  end

  namespace :admins do
    resources :cars, only: [] do
      collection do
        get :index
      end
    end
  end

  namespace :admins do
    resources :guidelines, only: [] do
      collection do
        get :terms_and_conditions
        get :privacy_policy
        get :faqs
      end
    end
  end

  namespace :admins do
    resources :supports, only: [] do
      collection do
        get :index
      end
    end
  end

  devise_for :admins,
  controllers: {
      passwords: 'admins/passwords'
  }
  
  get '/*a', to: 'api/v1/api#not_found'
end
