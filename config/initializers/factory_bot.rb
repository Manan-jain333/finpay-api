require 'factory_bot_rails'

# Include factory methods everywhere (console, tests, etc.)
module FactoryBot::ConsoleMethods
  include FactoryBot::Syntax::Methods
end

Rails.application.config.after_initialize do
  if defined?(Rails::Console)
    Object.include FactoryBot::ConsoleMethods
  end
end
