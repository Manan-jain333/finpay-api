class ReceiptProcessorWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3, queue: :default

  # Performs post-processing when a receipt or expense changes.
  # attrs should include:
  # { event: 'expense_created'|'status_changed'|'receipt_uploaded', expense_id: <id>, receipt_id: <id>, meta: { ... } }
  def perform(attrs)
    attrs = attrs.with_indifferent_access
    event = attrs[:event]

    case event
    when 'expense_created'
      process_expense_created(attrs[:expense_id], attrs[:meta] || {})
    when 'status_changed'
      process_status_changed(attrs[:expense_id], attrs[:meta] || {})
    when 'receipt_uploaded'
      process_receipt_uploaded(attrs[:receipt_id], attrs[:meta] || {})
    else
      logger.warn "ReceiptProcessorWorker: unknown event #{event.inspect}"
    end
  rescue StandardError => e
    logger.error "ReceiptProcessorWorker failed: #{e.class} - #{e.message}\n#{e.backtrace.join('\n')}"
    raise
  end

  private

  def process_expense_created(expense_id, _meta)
    expense = Expense.find_by(id: expense_id)
    return unless expense

    # placeholder processing: e.g., validate receipts, extract OCR, notify
    logger.info "Processing expense_created for Expense##{expense.id}"
  end

  def process_status_changed(expense_id, meta)
    expense = Expense.find_by(id: expense_id)
    return unless expense

    old_status = meta['from'] || meta[:from]
    new_status = meta['to'] || meta[:to]
    logger.info "Processing status_changed for Expense##{expense.id}: #{old_status} -> #{new_status}"
  end

  def process_receipt_uploaded(receipt_id, _meta)
    receipt = Receipt.find_by(id: receipt_id)
    return unless receipt

    # placeholder: process image, create thumbnails, OCR, etc.
    logger.info "Processing receipt_uploaded for Receipt##{receipt.id}"
  end
end
