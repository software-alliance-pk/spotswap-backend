Rails.application.routes.draw do
  root to: "admins/dashboard#index"
  mount ActionCable.server => "/cable"

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
          post :get_car_profile
          post :add_fcm_token
          post :notification_fcm_token
          post :logout
        end
      end

      resources :stripe_connects, only: [] do
        get :refresh_stripe_account_link
        get :user_stripe_connect_account
      end

      resources :cards ,only: [] do
        collection do
          get :get_all_cards
          post :create_card
          post :get_card
          post :update_card
          post :destroy_card
          post :set_default_card
          get :get_default_card
        end
      end

      resources :messages ,only: [] do
        collection do
          get :get_all_conversations
          post :get_all_messages
          post :create_message
          post :delete_message
          post :delete_conversation
          post :block_or_unblock_user
          post :create_conversation
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
          get :index
        end
      end
      
      resources :supports, only: [] do
        collection do
          post :create_ticket
          post :create_message
          post :get_all_support_messages
          get :get_tickets
        end
      end

      resources :faqs, only: [] do
        collection do
          get :index
          post :create_faq
          post :update_faq
          post :delete_faq
        end
      end

      resources :parking_slots, only: [] do
        collection do
          post :create_slot
          post :make_slot_available_or_unavailable
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
        get :sub_admins_index
        post :create_sub_admin
        post :delete_sub_admin
      end
    end

    resources :users, only: [] do
      collection do
        get :index
      end
    end

    resources :cars, only: [] do
      collection do
        get :index
        get :edit_model
        get :get_model_details
        get :delete_model
        post :create_brand
        post :create_model
        post :update_model
      end
    end

    resources :guidelines, only: [] do
      collection do
        get :terms_and_conditions
        get :privacy_policy
        get :faqs
      end
    end

    resources :supports, only: [] do
      collection do
        get :index
        post :admin_send_message
      end
    end
  end

  devise_for :admins,
  controllers: {
      passwords: 'admins/passwords'
  }
  
  get '/*a', to: 'api/v1/api#not_found'
end
