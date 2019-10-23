Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :issues
      resource :signup, only: :create
      resource :login, only: :create
    end
  end
end
