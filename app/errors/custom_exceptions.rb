# app/errors/custom_exceptions.rb
module Errors
  class ServiceError < StandardError; end
  class NotFoundError < ServiceError; end
  class UnauthorizedError < ServiceError; end
  class TenantNotFoundError < ServiceError; end
end
