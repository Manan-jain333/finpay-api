require 'rails_helper'

RSpec.describe AuditLogWorker, type: :worker do
  let(:user) { create(:user) }
  let(:expense) { create(:expense, employee: user) }

  it 'creates an ActivityLog with provided attributes' do
    attrs = {
      action: 'approve',
      record_type: 'Expense',
      record_id: expense.id,
      user_id: user.id,
      metadata: { 'note' => 'approved by system' }
    }

    expect {
      described_class.new.perform(attrs)
    }.to change { ActivityLog.count }.by(1)

    log = ActivityLog.last
    expect(log.action).to eq('approve')
    expect(log.record).to eq(expense)
    expect(log.user_id).to eq(user.id)
    expect(log.metadata['note']).to eq('approved by system')
  end
end
