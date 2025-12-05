# spec/support/auth_helpers.rb
module AuthHelpers
  def auth_headers(user)
    token = user.generate_jwt
    {
      "Authorization" => "Bearer #{token}",
      "Accept" => "application/json"
    }
  end
end
