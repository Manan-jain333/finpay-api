class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    if request.format.json?
      token = resource.generate_jwt
      render json: {
        message: "Logged in successfully",
        user: resource,
        token: token
      }, status: :ok
    else
      redirect_to stored_location_for(resource) || '/', notice: 'Signed in successfully.'
    end
  end

  def destroy
    if current_user
      sign_out(current_user)
      if request.format.json?
        render json: { message: "Logged out successfully" }, status: :ok
      else
        redirect_to '/', notice: 'Signed out successfully.'
      end
    else
      if request.format.json?
        render json: { error: "User not logged in" }, status: :unauthorized
      else
        redirect_to new_user_session_path, alert: 'User not logged in'
      end
    end
  end

  private

  # 🚀 MUST-HAVE FOR API-ONLY MODE
  def set_flash_message!(*args); end
  def set_flash_message(*args); end
end
