# app/controllers/concerns/tenant_loader.rb
module TenantLoader
  extend ActiveSupport::Concern

  included do
    before_action :load_tenant
  end

  private

  def load_tenant
    # Example: fetch tenant from header `X-Tenant` or param `tenant`
    tenant = request.headers['X-Tenant'].presence || params[:tenant].presence
    return unless tenant

    begin
      Apartment::Tenant.switch!(tenant)
    rescue StandardError => e
      raise TenantNotFoundError, "Tenant '#{tenant}' not found"
    end
  end
end
