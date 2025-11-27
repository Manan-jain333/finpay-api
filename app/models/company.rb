class Company < ApplicationRecord
  after_create :create_tenant_schema

  private

  def create_tenant_schema
    Apartment::Tenant.create(schema_name)
  end
end
