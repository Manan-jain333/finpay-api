require 'rails_helper'

RSpec.describe "Sessions API", type: :request do
  let(:user) { create(:user, email: "test@example.com", password: "password123") }

  describe "POST /users/sign_in" do
    it "returns a token on successful login" do
      post "/users/sign_in", params: {
        user: {
          email: user.email,
          password: "password123"
        }
      }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      
      expect(json_response).to have_key("token")
      expect(json_response["token"]).to be_present
      expect(json_response["message"]).to eq("Logged in successfully")
      expect(json_response).to have_key("user")
    end

    it "returns an error for invalid credentials" do
      post "/users/sign_in", params: {
        user: {
          email: user.email,
          password: "wrongpassword"
        }
      }

      expect(response).to have_http_status(422)
    end
  end
end
