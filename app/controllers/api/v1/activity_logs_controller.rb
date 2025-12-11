class Api::V1::ActivityLogsController < ApplicationController
  include AuthenticatedController

  def index
    activity_logs = ActivityLog.includes(:user, :record)
                               .order(created_at: :desc)
                               .page(params[:page])
                               .per(params[:per_page] || 20)

    render json: {
      activity_logs: activity_logs.map { |log| ActivityLogSerializer.new(log).serialize },
      pagination: {
        current_page: activity_logs.current_page,
        total_pages: activity_logs.total_pages,
        total_count: activity_logs.total_count,
        per_page: activity_logs.limit_value
      }
    }, status: :ok
  end

  def show
    activity_log = ActivityLog.find(params[:id])
    render json: ActivityLogSerializer.new(activity_log).serialize, status: :ok
  end

  # Filter by expense ID
  def by_expense
    expense_id = params[:expense_id]
    activity_logs = ActivityLog.where(record_type: 'Expense', record_id: expense_id)
                             .includes(:user)
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(params[:per_page] || 20)

    render json: {
      activity_logs: activity_logs.map { |log| ActivityLogSerializer.new(log).serialize },
      pagination: {
        current_page: activity_logs.current_page,
        total_pages: activity_logs.total_pages,
        total_count: activity_logs.total_count,
        per_page: activity_logs.limit_value
      }
    }, status: :ok
  end
end
