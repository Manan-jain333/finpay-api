require 'rails_helper'
require '/Users/manan/finpay-api/spec/support/auth_helpers.rb'

RSpec.describe "Receipts API", type: :request do
  let(:user) { create(:user) }
  let(:expense) { create(:expense, employee: user, category: create(:category)) }
  let(:headers) { auth_headers(user) }

  describe "POST /receipts" do
    it "creates a receipt" do
      post "/receipts", params: {
        receipt: {
          expense_id: expense.id,
          file_url: "test.png"
        }
      }, headers: headers

      expect(response).to have_http_status(:created)
    end
  end
end
