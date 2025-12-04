Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    post "/users/sign_in", to: "users/sessions#create"
    post "/users", to: "users/registrations#create"
  end

  resources :categories

  resources :expenses do
    member do
      patch :approve     # /expenses/:id/approve
      patch :reject      # /expenses/:id/reject
      patch :reimburse   # /expenses/:id/reimburse
      patch :archive     # /expenses/:id/archive
    end
  end

  resources :receipts
end
