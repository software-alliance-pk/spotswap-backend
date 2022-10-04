Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  post '/auth/login', to: 'authentication#login'

  resources :social_login , only: [] do
    collection do
      post :social_login
    end
  end
  get '/*a', to: 'application#not_found'
end
