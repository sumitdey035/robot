# frozen_string_literal: true

Rails.application.routes.draw do
  resources :toys, except: %i[edit update] do
    member do
      get :run
    end
  end
  root 'toys#index'
end
