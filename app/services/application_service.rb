# app/services/application_service.rb
class ApplicationService
  # Call a service class with `.call(*args)`
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
    raise NotImplementedError, "Service must implement #call"
  end
end
