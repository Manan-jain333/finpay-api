class Company < ApplicationRecord
  validates :name, presence: true
  validates :schema_name, presence: true, uniqueness: true

  after_create :create_tenant

  private

  def create_tenant
    Apartment::Tenant.create(:name)
  end
end
