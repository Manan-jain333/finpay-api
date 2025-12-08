require 'rails_helper'

RSpec.describe ReceiptProcessorWorker, type: :worker do
  let(:user) { create(:user) }
  let(:expense) { create(:expense, employee: user) }
  let(:receipt) { create(:receipt, expense: expense) }

  describe '#perform' do
    it 'processes expense_created without raising' do
      expect {
        described_class.new.perform({ 'event' => 'expense_created', 'expense_id' => expense.id })
      }.not_to raise_error
    end

    it 'processes status_changed with meta data without raising' do
      meta = { 'from' => 'pending', 'to' => 'approved' }
      expect {
        described_class.new.perform({ 'event' => 'status_changed', 'expense_id' => expense.id, 'meta' => meta })
      }.not_to raise_error
    end

    it 'processes receipt_uploaded without raising' do
      expect {
        described_class.new.perform({ 'event' => 'receipt_uploaded', 'receipt_id' => receipt.id })
      }.not_to raise_error
    end

    it 'handles unknown events gracefully (no raise)' do
      expect {
        described_class.new.perform({ 'event' => 'unknown_event', 'expense_id' => expense.id })
      }.not_to raise_error
    end

    it 'does not raise when target record is missing' do
      # Use non-existent ids
      expect {
        described_class.new.perform({ 'event' => 'expense_created', 'expense_id' => 0 })
        described_class.new.perform({ 'event' => 'receipt_uploaded', 'receipt_id' => 0 })
      }.not_to raise_error
    end
  end
end
