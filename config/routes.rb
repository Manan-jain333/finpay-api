Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  # Allow Devise public access
  devise_scope :user do
    post "/users/sign_in", to: "users/sessions#create"
    post "/users", to: "users/registrations#create"
  end

  resources :categories
  resources :expenses
  resources :receipts
end
