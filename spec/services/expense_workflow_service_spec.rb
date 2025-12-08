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

  describe '#reimburse!' do
    it 'transitions approved expense to reimbursed and enqueues worker' do
      approved = create(:expense, :approved, employee: user)
      service = ExpenseWorkflowService.new(approved, user)

      expect {
        service.reimburse!(note: 'Pay out')
      }.to change { ReceiptProcessorWorker.jobs.size }.by(1)

      expect(approved).to be_reimbursed
      log = ActivityLog.where(record: approved).last
      expect(log.action).to eq('reimburse')
      expect(log.metadata['note']).to eq('Pay out')
    end
  end

  describe '#archive!' do
    it 'archives a reimbursed expense' do
      reimbursed = create(:expense, :reimbursed, employee: user)
      service = ExpenseWorkflowService.new(reimbursed, user)

      service.archive!(note: 'Cleanup')
      expect(reimbursed).to be_archived
      log = ActivityLog.where(record: reimbursed).last
      expect(log.action).to eq('archive')
      expect(log.metadata['note']).to eq('Cleanup')
    end
  end

  describe 'failure cases' do
    it 'raises WorkflowError when event not permitted' do
      approved = create(:expense, :approved, employee: user)
      service = ExpenseWorkflowService.new(approved, user)

      expect { service.approve! }.to raise_error(ExpenseWorkflowService::WorkflowError, /Cannot approve/)
    end

    it 'raises WorkflowError when persistence fails after transition' do
      # make model invalid after transition by clearing a required attribute
      service = ExpenseWorkflowService.new(expense, user)
      expense.title = nil

      expect { service.approve! }.to raise_error(ExpenseWorkflowService::WorkflowError, /Failed to persist/)
    end
  end

  describe '#force_transition!' do
    it 'forces status and creates an ActivityLog' do
      service = ExpenseWorkflowService.new(expense, user)

      service.send(:force_transition!, 'archived', { 'note' => 'admin override' })

      expect(expense.reload.status).to eq('archived')
      log = ActivityLog.where(record: expense).last
      expect(log.action).to eq('force_transition')
      expect(log.metadata['to']).to eq('archived')
    end
  end
end
