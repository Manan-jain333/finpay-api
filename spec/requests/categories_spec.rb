require 'rails_helper'

RSpec.describe "Categories API", type: :request do
  let(:user)     { create(:user) }
  let(:headers)  { auth_headers(user) }

  describe "GET /categories" do
    it "returns all categories" do
      create_list(:category, 3)
      get "/categories", headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /categories" do
    it "creates a category" do
      post "/categories", params: { category: { name: "Travel" } }, headers: headers
      expect(response).to have_http_status(:created)
    end

    it "fails without a name" do
      post "/categories", params: { category: { name: "" } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
