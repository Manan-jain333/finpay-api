   # config/application.rb
require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module FinpayApi
  class Application < Rails::Application
    config.load_defaults 7.1
    # removed unsupported `autoload_lib` call which caused frozen path errors
    config.active_job.queue_adapter = :sidekiq

    # Add app/errors to the autoload/eager load paths safely
    config.paths.add "app/errors", eager_load: true


    # API mode is ON
    config.api_only = true

    # Enable cookies & sessions for Devise
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    # Enable flash messages (needed for Devise HTML flows / redirects)
    config.middleware.use ActionDispatch::Flash
    # Request throttling via Rack::Attack
    config.middleware.use Rack::Attack
  end
end
