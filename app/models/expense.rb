class Expense < ApplicationRecord
  belongs_to :category
  belongs_to :employee, class_name: "User", optional: true
  has_many :receipts

  enum status: { pending: 0, approved: 1, rejected: 2 }

  # 👇 Individual scopes
  scope :by_category, ->(category_id) { where(category_id:) if category_id.present? }
  scope :by_status, ->(status) { where(status:) if status.present? }
  scope :from_date, ->(start_date) { where("date >= ?", start_date) if start_date.present? }
  scope :to_date, ->(end_date) { where("date <= ?", end_date) if end_date.present? }

  # 👇 Master scope combining all
  scope :filtered, ->(params) do
    by_category(params[:category_id])
      .by_status(params[:status])
      .from_date(params[:start_date])
      .to_date(params[:end_date])
  end
end
