class Expense < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :category
  belongs_to :employee, class_name: "User", required: true
  has_many :receipts, dependent: :destroy

  include AASM

  # RAILS ENUM FOR STATUS (required for shoulda-matchers + AASM)
  # Allowed statuses (AASM will manage transitions). We keep a constant
  # so other code can reference the valid status values without relying
  # on ActiveRecord enums.
  STATUSES = %w[pending approved rejected reimbursed archived].freeze

  # AASM STATE MACHINE

  aasm column: :status do
    state :pending, initial: true
    state :approved
    state :rejected
    state :reimbursed
    state :archived

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :reimburse do
      transitions from: :approved, to: :reimbursed
    end

    event :archive do
      transitions from: [:rejected, :reimbursed], to: :archived
    end
  end

  # VALIDATIONS
  validates :title, presence: true
  validates :date, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  after_create :enqueue_receipt_processor_on_create

  private

  def enqueue_receipt_processor_on_create
    ReceiptProcessorWorker.perform_async({ 'event' => 'expense_created', 'expense_id' => id })
  end

  # FILTERING SCOPES
  scope :by_category, ->(category_id) { where(category_id:) if category_id.present? }
  scope :by_status, ->(status) { where(status:) if status.present? }
  scope :from_date, ->(start_date) { where("date >= ?", start_date) if start_date.present? }
  scope :to_date, ->(end_date) { where("date <= ?", end_date) if end_date.present? }

  scope :filtered, ->(params) do
    by_category(params[:category_id])
      .by_status(params[:status])
      .from_date(params[:start_date])
      .to_date(params[:end_date])
  end
end
