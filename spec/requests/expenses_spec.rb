require 'rails_helper'

RSpec.describe 'Expenses API', type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:headers) { auth_headers(user) }

  describe 'POST /expenses' do
    it 'creates an expense when authenticated and enqueues worker' do
      expect(ReceiptProcessorWorker).to receive(:perform_async).with(hash_including('event' => 'expense_created'))

      expect {
        post '/expenses', params: { expense: { title: 'Train Ticket', amount: 12.5, date: Date.today, category_id: category.id, employee_id: user.id } }, headers: headers
      }.to change(Expense, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body).to be_a(Hash)
      expect(body['title'] || body['data']).to be_present
    end

    it 'returns 422 for invalid data' do
      post '/expenses', params: { expense: { title: '', amount: -1, date: '' } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body['errors']).to be_present
    end

    it 'returns 401 when not authenticated' do
      post '/expenses', params: { expense: { title: 'x', amount: 1, date: Date.today } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /expenses' do
    before do
      create(:expense, category: category, employee: user)
      create(:expense, :approved, category: category, employee: user)
    end

    it 'returns expenses list' do
      get '/expenses', headers: headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to be_a(Array)
      expect(body).not_to be_empty
      expect(body.first).to be_a(Hash)
    end

    it 'supports filtering by status' do
      get '/expenses', params: { status: 'approved' }, headers: headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to be_a(Array)
      expect(body).not_to be_empty
      expect(body.first['status']).to eq('approved')
    end
  end

  describe 'GET /expenses/:id' do
    it 'returns the expense' do
      expense = create(:expense, category: category, employee: user)
      get "/expenses/#{expense.id}", headers: headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to be_a(Hash)
    end
  end
end
