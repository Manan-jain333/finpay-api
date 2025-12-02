class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { employee: 0, manager: 1, admin: 2 }

  validates :role, presence: true
end
