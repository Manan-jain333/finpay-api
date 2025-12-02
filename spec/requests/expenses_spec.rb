require 'rails_helper'

RSpec.describe "Expenses API", type: :request do
  let!(:employee) { Employee.create!(name: "John", email: "john@example.com", age: 28) }
  let!(:category) { Category.create!(name: "Travel") }

  describe "POST /expenses" do
    it "creates an expense" do
      post "/expenses", params: {
        expense: {
          title: "Hotel stay",
          amount: 4000,
          date: "2025-12-01",
          employee_id: employee.id,
          category_id: category.id
        }
      }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["title"]).to eq("Hotel stay")
    end
  end

  describe "GET /expenses" do
    it "returns expenses" do
      Expense.create!(title: "Taxi", amount: 500, date: "2025-12-01", employee_id: employee.id, category_id: category.id)

      get "/expenses"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.length).to eq(1)
    end
  end
end
