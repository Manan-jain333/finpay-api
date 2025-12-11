Rails.application.routes.draw do
  require 'sidekiq/web'

  # Swagger
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      devise_for :users, path: 'users', controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }

      devise_scope :user do
        post '/users/sign_in', to: 'users/sessions#create'
        post '/users', to: 'users/registrations#create'
      end

      resources :companies
      resources :categories
      resources :expenses do
        member do
          patch :approve
          patch :reject
          patch :reimburse
          patch :archive
        end
      end
      resources :receipts
      resources :activity_logs, only: [:index, :show] do
        collection do
          get :by_expense
        end
      end
      resources :jobs, only: [] do
        collection do
          get :stats
          get :queue
          get :failed
          post :test
        end
      end
    end
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
end
