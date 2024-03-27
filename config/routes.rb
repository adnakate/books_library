Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :transactions do
        post :place_order, on: :collection
        patch :return_items, on: :collection
      end
      resources :items, only: [:index]
      resources :users do
        get :transactions, on: :collection
      end
    end
  end
end
