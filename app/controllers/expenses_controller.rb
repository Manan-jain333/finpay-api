class ExpensesController < ApplicationController
  include AuthenticatedController
  before_action :set_expense, only: [:show, :update, :destroy, :approve, :reject, :reimburse, :archive]

  def index
    expenses = Expense.filtered(params)
                      .includes(:category, :employee)
                      .page(params[:page])
                      .per(params[:per_page] || 10)

    render json: ExpensesListSerializer.new(expenses).serialize, status: :ok
  end

  def show
    render json: ExpenseSerializer.new(@expense).serialize, status: :ok
  end

  def create
    expense = Expense.new(expense_params)
    if expense.save
      render json: ExpenseSerializer.new(expense).serialize, status: :created
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      render json: ExpenseSerializer.new(@expense).serialize, status: :ok
    else
      render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    head :no_content
  end

  # -------------------------------------------------------
  # 🚦 WORKFLOW ACTIONS (AASM STATE MACHINE)
  # -------------------------------------------------------

  def approve
    service = ExpenseWorkflowService.new(@expense, current_user)
    begin
      service.approve!(note: params[:note])
      render json: { message: "Expense approved", status: @expense.status }, status: :ok
    rescue ExpenseWorkflowService::WorkflowError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def reject
    service = ExpenseWorkflowService.new(@expense, current_user)
    begin
      service.reject!(reason: params[:reason])
      render json: { message: "Expense rejected", status: @expense.status }, status: :ok
    rescue ExpenseWorkflowService::WorkflowError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def reimburse
    service = ExpenseWorkflowService.new(@expense, current_user)
    begin
      service.reimburse!(note: params[:note])
      render json: { message: "Expense reimbursed", status: @expense.status }, status: :ok
    rescue ExpenseWorkflowService::WorkflowError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def archive
    service = ExpenseWorkflowService.new(@expense, current_user)
    begin
      service.archive!(note: params[:note])
      render json: { message: "Expense archived", status: @expense.status }, status: :ok
    rescue ExpenseWorkflowService::WorkflowError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:title, :amount, :date, :status, :employee_id, :category_id)
  end
end
