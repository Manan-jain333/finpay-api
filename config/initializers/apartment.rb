Apartment.configure do |config|
  # Tell apartment to use Postgres schemas
  config.use_schemas = true

  # Exclude public schema
  config.excluded_models = %w[Company]

  # Load tenants dynamically from database
  config.tenant_names = -> { Company.pluck(:name) }
end
