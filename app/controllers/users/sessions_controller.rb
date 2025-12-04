class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    token = resource.generate_jwt
    render json: { 
      message: "Logged in successfully", 
      user: resource,
      token: token
    }, status: :ok
  end

  def destroy
    if current_user
      sign_out(current_user)
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { error: "User not logged in" }, status: :unauthorized
    end
  end
end
