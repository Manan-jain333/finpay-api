   # config/application.rb
require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module FinpayApi
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w(assets tasks))
    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths << Rails.root.join("app/errors")


    # API mode is ON
    config.api_only = true

    # Enable cookies & sessions for Devise
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    # Enable flash messages (needed for Devise HTML flows / redirects)
    config.middleware.use ActionDispatch::Flash
  end
end
