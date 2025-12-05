# app/workers/audit_log_worker.rb
class AuditLogWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3, queue: :default

  # Expects a hash like:
  # { action: 'approve', record_type: 'Expense', record_id: 1, user_id: 2, metadata: { note: '...' } }
  def perform(attrs)
    attrs = attrs.with_indifferent_access

    ActivityLog.create!(
      action: attrs[:action],
      record_type: attrs[:record_type],
      record_id: attrs[:record_id],
      user_id: attrs[:user_id],
      metadata: attrs[:metadata] || {}
    )
  rescue StandardError => e
    logger.error "AuditLogWorker failed to create ActivityLog: #{e.class} - #{e.message}"
    raise
  end
end
