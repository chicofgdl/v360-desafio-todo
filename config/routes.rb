Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  root "lists#index"
  resources :lists do
    resources :tasks, only: %i[create edit update destroy] do
      collection do
        patch :reorder
      end
      member do
        patch :toggle
      end
    end
  end
end
