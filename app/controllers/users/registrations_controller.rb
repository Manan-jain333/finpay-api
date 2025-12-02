class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!, only: [:create]
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: "Signup successful", user: resource }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
