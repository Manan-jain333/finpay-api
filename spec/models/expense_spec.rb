require 'rails_helper'

RSpec.describe Expense, type: :model do
  # Associations
  it { should belong_to(:employee) }
  it { should belong_to(:category) }
  it { should have_many(:receipts).dependent(:destroy) }

  # Validations
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount).is_greater_than(0) }
end
