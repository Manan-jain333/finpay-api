require 'rails_helper'

RSpec.describe ExpenseWorkflowService, type: :service do
  let(:user) { create(:user) }
  let(:expense) { create(:expense, employee: user) }

  describe '#approve!' do
    it 'transitions expense to approved and creates an ActivityLog' do
      service = ExpenseWorkflowService.new(expense, user)
      service.approve!(note: 'Looks good')

      expect(expense).to be_approved
      log = ActivityLog.where(record: expense).last
      expect(log).to be_present
      expect(log.action).to eq('approve')
      expect(log.user).to eq(user)
      expect(log.metadata['note']).to eq('Looks good')
    end
  end

  describe '#reject!' do
    it 'transitions expense to rejected and creates an ActivityLog' do
      service = ExpenseWorkflowService.new(expense, user)
      service.reject!(reason: 'Not valid')

      expect(expense).to be_rejected
      log = ActivityLog.where(record: expense).last
      expect(log.action).to eq('reject')
      expect(log.metadata['reason']).to eq('Not valid')
    end
  end
end
