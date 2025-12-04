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
    if @expense.may_approve?
      @expense.approve!
      render json: { message: "Expense approved", status: @expense.status }, status: :ok
    else
      render json: { error: "Cannot approve this expense" }, status: :unprocessable_entity
    end
  end

  def reject
    if @expense.may_reject?
      @expense.reject!
      render json: { message: "Expense rejected", status: @expense.status }, status: :ok
    else
      render json: { error: "Cannot reject this expense" }, status: :unprocessable_entity
    end
  end

  def reimburse
    if @expense.may_reimburse?
      @expense.reimburse!
      render json: { message: "Expense reimbursed", status: @expense.status }, status: :ok
    else
      render json: { error: "Cannot reimburse this expense" }, status: :unprocessable_entity
    end
  end

  def archive
    if @expense.may_archive?
      @expense.archive!
      render json: { message: "Expense archived", status: @expense.status }, status: :ok
    else
      render json: { error: "Cannot archive this expense" }, status: :unprocessable_entity
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
