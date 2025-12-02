class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: "Signup successful", user: resource }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
