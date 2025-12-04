# app/controllers/concerns/authenticated_controller.rb
module AuthenticatedController
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    auth_header = request.headers['Authorization']
    token = auth_header.to_s.split(' ').last

    begin
      payload = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      @current_user = User.find(payload["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
