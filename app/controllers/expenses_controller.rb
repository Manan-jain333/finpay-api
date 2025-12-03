class ExpensesController < ApplicationController
  include AuthenticatedController

  def index
    expenses = Expense.filtered(params)
                      .includes(:category, :employee)
                      .page(params[:page])
                      .per(params[:per_page] || 10)

    render json: ExpensesListSerializer.new(expenses).serialize
  end


  def show
    expense = Expense.find(params[:id])
    render json: ExpenseSerializer.new(expense).serialize
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
    expense = Expense.find(params[:id])
    if expense.update(expense_params)
      render json: ExpenseSerializer.new(expense).serialize
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Expense.find(params[:id]).destroy
    head :no_content
  end

  private

  def expense_params
    params.require(:expense).permit(:title, :amount, :date, :status, :employee_id, :category_id)
  end

  def filter_params
    params.permit(:category_id, :status, :start_date, :end_date)
  end
end
