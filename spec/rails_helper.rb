require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Workers', 'app/workers'
  add_group 'Serializers', 'app/serializers'
end
if ENV['CI'] || ENV['SIMPLECOV_MINIMUM']
  SimpleCov.minimum_coverage 90
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Auto-require all files in spec/support
Rails.root.glob('spec/support/**/*.rb').each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = true

  # Include FactoryBot methods like `create`, `build`
  config.include FactoryBot::Syntax::Methods

  # Include custom authentication helpers only for request specs
  config.include AuthHelpers, type: :request

  config.filter_rails_from_backtrace!
end

# Shoulda matchers setup
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
