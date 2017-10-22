Rails.application.routes.draw do
  resources :toys, except: [:edit, :update] do
    member do
      get :run
    end
  end
  root 'toys#index'
end
