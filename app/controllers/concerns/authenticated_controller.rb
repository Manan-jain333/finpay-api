# app/controllers/concerns/authenticated_controller.rb
module AuthenticatedController
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  # Custom JSON-based auth using Devise helpers
  def authenticate_user!
    unless user_signed_in?
      render json: { error: "You need to sign in before continuing" }, status: :unauthorized
    end
  end
end
