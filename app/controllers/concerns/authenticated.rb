# app/controllers/concerns/authenticated.rb
module Authenticated
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api_user!
  end

  private

  def authenticate_api_user!
    header = request.headers["Authorization"]
    return unauthorized_response unless header.present?

    token = header.split(" ").last

    begin
      decoded = JWT.decode(
        token,
        Rails.application.credentials.secret_key_base, # 🔴 SAME as in User#generate_jwt
        true,
        algorithm: "HS256"
      )

      @current_user = User.find(decoded.first["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      unauthorized_response
    end
  end

  def unauthorized_response
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
