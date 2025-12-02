class Receipt < ApplicationRecord
  belongs_to :expense

  validates :file_url, presence: true
end
