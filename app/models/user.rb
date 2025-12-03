class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { employee: 0, manager: 1, admin: 2 }, _default: :employee

  validates :role, presence: true
end
