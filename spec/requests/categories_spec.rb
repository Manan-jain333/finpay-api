require 'rails_helper'

RSpec.describe "Categories API", type: :request do
  describe "GET /categories" do
    it "returns all categories" do
      Category.create!(name: "Travel")
      Category.create!(name: "Food")

      get "/categories"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.length).to eq(2)
    end
  end

  describe "POST /categories" do
    it "creates a category" do
      post "/categories", params: {
        category: {
          name: "Electronics",
          description: "Devices"
        }
      }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["name"]).to eq("Electronics")
    end

    it "fails without a name" do
      post "/categories", params: { category: { name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
