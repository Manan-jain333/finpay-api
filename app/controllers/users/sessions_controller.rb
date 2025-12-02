class Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]

  private

  def respond_with(resource, _opts = {})
    render json: {
      message: "Logged in successfully",
      user: resource
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { message: "User not logged in" }, status: :unauthorized
    end
  end
end
