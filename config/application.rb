# config/application.rb
require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module FinpayApi
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w(assets tasks))

    # API mode is ON
    config.api_only = true

    # Enable cookies & sessions for Devise
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
  end
end
