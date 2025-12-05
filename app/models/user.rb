# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { employee: 0, manager: 1, admin: 2 }, _default: :employee

  validates :role, presence: true

  def generate_jwt
    JWT.encode(
      { user_id: id, exp: 7.days.from_now.to_i },
      Rails.application.credentials.secret_key_base
    )
  end
end
