require 'rails_helper'

RSpec.describe Receipt, type: :model do
  # Associations
  it { should belong_to(:expense) }

  # Validations
  it { should validate_presence_of(:file_url) }
end
