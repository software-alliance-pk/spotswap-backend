Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :authentication ,only: [] do
        collection do
          post :login
          post :sign_up
          get :get_car_brands
        end
      end
      resources :users
    end
  end

  resources :social_login , only: [] do
    collection do
      post :social_login
    end
  end

  resources :static_pages, param: :permalink ,only: [] do
    member do
      post :index
    end
  end
  
  get '/*a', to: 'api/v1/api#not_found'
end
