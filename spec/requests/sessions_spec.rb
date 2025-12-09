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
      }, headers: { 'ACCEPT' => 'application/json' }

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

    it 'supports HTML form login and redirects' do
      post "/users/sign_in", params: {
        user: {
          email: user.email,
          password: "password123"
        }
      }, headers: { 'ACCEPT' => 'text/html' }

      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/')
    end
  end

  describe 'DELETE /users/sign_out' do
    it 'logs out JSON session after login' do
      # login via JSON to set session and receive token
      post "/users/sign_in", params: { user: { email: user.email, password: 'password123' } }, headers: { 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:ok)

      delete "/users/sign_out", headers: { 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['message']).to eq('Logged out successfully')
    end

    it 'logs out HTML session and redirects' do
      # HTML login (creates session cookie)
      post "/users/sign_in", params: { user: { email: user.email, password: 'password123' } }
      expect(response).to have_http_status(302)

      delete "/users/sign_out"
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/')
    end
  end
end
