class Company < ApplicationRecord
  validates :name, :subdomain, presence: true

  before_create :assign_schema_name
  after_create :create_tenant

  private

  def assign_schema_name
    self.schema_name = subdomain.downcase
  end

  def create_tenant
    return if tenant_exists?(schema_name)

    Apartment::Tenant.create(schema_name)
  end

  def tenant_exists?(schema)
    ActiveRecord::Base.connection.schema_exists?(schema)
  end
end
