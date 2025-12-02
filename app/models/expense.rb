class Expense < ApplicationRecord
  belongs_to :employee
  belongs_to :category
  has_many :receipts, dependent: :destroy

  validates :title, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
end
