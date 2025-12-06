# app/controllers/concerns/api_responder.rb
module ApiResponder
  extend ActiveSupport::Concern

  included do
    # render a standard JSON success response
    def render_success(data: {}, message: nil, status: :ok)
      payload = { success: true }
      payload[:message] = message if message.present?
      payload[:data] = data unless data.nil?
      render json: payload, status: status
    end

    # render a standard JSON error response
    def render_error(message: nil, errors: nil, status: :unprocessable_entity)
      payload = { success: false }
      payload[:message] = message if message.present?
      payload[:errors] = errors if errors.present?
      render json: payload, status: status
    end
  end
end
