Rails.application.routes.draw do
  require 'sidekiq/web'
  # Swagger UI and API (rswag)
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Secure Sidekiq Web UI using Devise authentication (only admin users).
  # Ensure `config.middleware.use ActionDispatch::Cookies` and
  # `ActionDispatch::Session::CookieStore` are enabled in
  # `config/application.rb` so Devise sessions work for the web UI.
    # Mount Sidekiq Web UI under `/admin/sidekiq` and protect it with Devise
    # admin authentication. This ensures only signed-in admin users can visit
    # the Sidekiq UI in the browser.
  mount Sidekiq::Web => '/sidekiq'

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

  # API namespace (versioned)
  scope path: '/api' do
    scope path: '/v1', defaults: { format: :json } do
      # Reuse existing controllers (no module) so controllers don't need to be moved.
      scope module: nil do
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
      end
    end
  end
end
