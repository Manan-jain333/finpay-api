class ExpensesController < ApplicationController
  def index
    expenses = Expense.includes(:category, :receipts)
    render json: ExpenseSerializer.new(expenses).serialize
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
    expense = Expense.find(params[:id])
    expense.destroy
    head :no_content
  end

  private

  def expense_params
    # assuming you send employee_id and category_id from client
    params.require(:expense).permit(:title, :amount, :date, :employee_id, :category_id)
  end
end
