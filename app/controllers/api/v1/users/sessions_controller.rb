class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]

  def create
    email = params[:user][:email] if params[:user].present?
    password = params[:user][:password] if params[:user].present?
    
    if email.blank? || password.blank?
      render json: { error: "Email and password are required" }, status: :unprocessable_entity
      return
    end
    
    # Find user by email
    user = User.find_by(email: email)
    
    # Authenticate user
    if user && user.valid_password?(password)
      sign_in(user)
      token = user.generate_jwt

      render json: {
        message: "Logged in successfully",
        token: token,
        user: user
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  protected

  def devise_controller?
    true
  end

  private

  # Required for API-only mode
  def set_flash_message!(*args); end
  def set_flash_message(*args); end
end
