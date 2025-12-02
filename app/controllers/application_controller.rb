# class ApplicationController < ActionController::API
#   include ActionController::Cookies
#   include Devise::Controllers::Helpers

#   before_action :authenticate_user!

#   private

#   # Let Devise do the main work, but customize the response for API
#   def authenticate_user!
#     unless user_signed_in?
#       render json: { error: "You need to sign in before continuing" }, status: :unauthorized
#     end
#   end
# end

class ApplicationController < ActionController::API
  include ActionController::Cookies
  before_action :authenticate_user!

  private

  def authenticate_user!
    unless user_signed_in?
      render json: { error: "You need to sign in before continuing" }, status: :unauthorized
    end
  end
end
