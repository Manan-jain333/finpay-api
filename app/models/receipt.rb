class Receipt < ApplicationRecord
  belongs_to :expense

  validates :file_url, presence: true

  after_create :enqueue_receipt_processor_on_upload

  private

  def enqueue_receipt_processor_on_upload
    ReceiptProcessorWorker.perform_async({ 'event' => 'receipt_uploaded', 'receipt_id' => id, 'expense_id' => expense_id })
  end
end
