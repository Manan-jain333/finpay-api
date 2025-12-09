require_relative '../errors/custom_exceptions'

class ApplicationController < ActionController::API
	include ApiResponder
	include ErrorHandler
	include TenantLoader

	# Handle custom service errors globally
	handle_errors Errors::ServiceError, status: :unprocessable_entity
	handle_errors Errors::NotFoundError, status: :not_found
	handle_errors Errors::UnauthorizedError, status: :unauthorized
	handle_errors Errors::TenantNotFoundError, status: :not_found
end
