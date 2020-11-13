Rails.application.routes.draw do
  root "tasks#index"
  resources :tasks
  resources :users, only: [:create] do
    collection do
      get :sign_up
      get :sign_in
      post :login
      delete :sign_out
    end
  end
end
