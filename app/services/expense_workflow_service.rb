# app/services/expense_workflow_service.rb
class ExpenseWorkflowService
  class WorkflowError < StandardError; end

  def initialize(expense, user = nil)
    @expense = expense
    @user = user
  end

  def approve!(note: nil)
    perform_transition(:approve, { note: note })
  end

  def reject!(reason: nil)
    perform_transition(:reject, { reason: reason })
  end

  def reimburse!(note: nil)
    perform_transition(:reimburse, { note: note })
  end

  def archive!(note: nil)
    perform_transition(:archive, { note: note })
  end

  private

  def perform_transition(event, metadata = {})
    ActiveRecord::Base.transaction do
      # Check whether the event can fire
      may_method = "may_#{event}?".to_sym
      unless @expense.respond_to?(may_method) && @expense.public_send(may_method)
        raise WorkflowError, "Cannot #{event} expense from status '#{@expense.status}'"
      end

      # Use non-bang event to get boolean result and inspect errors
      prior_status = @expense.status
      result = @expense.public_send(event)
      unless result
        raise WorkflowError, "Failed to #{event} expense: #{format_errors(@expense)}"
      end

      # If the event changed the in-memory state, persist it. This ensures
      # subsequent callers (and reloads) see the new state. If save fails
      # due to validations, raise a clear WorkflowError.
      if @expense.status != prior_status
        begin
          @expense.save!
        rescue ActiveRecord::RecordInvalid
          raise WorkflowError, "Failed to persist #{event} expense: #{format_errors(@expense)}"
        end
      end

      create_log(event.to_s, metadata)
      # Enqueue background processing for receipts/expense post-processing
      ReceiptProcessorWorker.perform_async({ 'event' => 'status_changed', 'expense_id' => @expense.id, 'meta' => { 'from' => prior_status, 'to' => @expense.status } })
    end

    @expense
  rescue AASM::InvalidTransition => e
    raise WorkflowError, e.message
  end

  def create_log(action, metadata = {})
    ActivityLog.create!(
      action: action,
      record: @expense,
      user: @user,
      metadata: metadata
    )
  end

  def format_errors(record)
    record.errors.full_messages.join(', ')
  end

  # Force the status of the expense to `to_state` regardless of AASM
  # This performs validations (via `update!`) and creates an ActivityLog.
  # Use with care — it bypasses the AASM transition guardrails.
  def force_transition!(to_state, metadata = {})
    to_state = to_state.to_s
    unless Expense::STATUSES.include?(to_state)
      raise WorkflowError, "Invalid status '#{to_state}'"
    end

    ActiveRecord::Base.transaction do
      @expense.update!(status: to_state)
      create_log("force_transition", metadata.merge({ "to" => to_state }))
    end

    @expense
  end
end
