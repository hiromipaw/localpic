Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      resources :pictures do
        member do
          delete 'destroy'
          patch 'update'
          get 'index'
          get 'show'
          post 'create'
        end
      end

      resource :filters do
        member do
          get 'index'
          delete 'destroy'
          get 'show'
          post 'create'
        end
      end
      
    end
  end
end
