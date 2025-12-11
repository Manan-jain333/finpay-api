class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  skip_before_action :authenticate_user!, only: [:create] # <-- add this too

  def create
    user = User.new(sign_up_params)

    if user.save
      render json: { message: "User created successfully", user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :role)
  end

  # 👇 ADD THIS SO AUTH IS SKIPPED FOR SIGNUP
  protected def devise_controller?
    true
  end
end
