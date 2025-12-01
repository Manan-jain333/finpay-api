require 'rails_helper'

RSpec.describe "Receipts API", type: :request do
  let!(:employee) { Employee.create!(name: "John", email: "john@example.com", age: 28) }
  let!(:category) { Category.create!(name: "Travel") }
  let!(:expense) { Expense.create!(title: "Hotel", amount: 4000, date: "2025-12-01", employee_id: employee.id, category_id: category.id) }

  describe "POST /receipts" do
    it "creates a receipt" do
      post "/receipts", params: {
        receipt: {
          file_url: "https://example.com/r1.png",
          expense_id: expense.id
        }
      }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["file_url"]).to eq("https://example.com/r1.png")
    end
  end
end
