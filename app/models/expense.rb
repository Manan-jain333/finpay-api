class Expense < ApplicationRecord
  belongs_to :category
  belongs_to :employee, class_name: "User", optional: true
  has_many :receipts

  enum status: { pending: 0, approved: 1, rejected: 2 }

  scope :filtered, ->(params) do
    expenses = all
    expenses = expenses.where(category_id: params[:category_id]) if params[:category_id].present?
    expenses = expenses.where(status: Expense.statuses[params[:status]]) if params[:status].present?
    expenses = expenses.where("date >= ?", params[:start_date]) if params[:start_date].present?
    expenses = expenses.where("date <= ?", params[:end_date]) if params[:end_date].present?
    expenses
  end
end
