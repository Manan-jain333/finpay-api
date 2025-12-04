require 'rails_helper'

RSpec.describe "Expenses API", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:headers) { auth_headers(user) }

  describe "POST /expenses" do
    it "creates an expense" do
      post "/expenses", params: {
        expense: {
          title: "Test Expense",
          amount: 100,
          date: Date.today,
          category_id: category.id,
          employee_id: user.id
        }
      }, headers: headers

      expect(response).to have_http_status(:created)
    end
  end

  describe "GET /expenses" do
    it "returns expenses" do
      create(:expense, category: category, employee: user)
      get "/expenses", headers: headers
      expect(response).to have_http_status(:ok)
    end
  end
end
