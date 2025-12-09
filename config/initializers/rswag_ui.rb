Rswag::Ui.configure do |c|
  # List the Swagger endpoints that will be available through the UI
  # new versions use `openapi_endpoint` (rswag-ui v3+)
  if c.respond_to?(:openapi_endpoint)
    c.openapi_endpoint '/api-docs/v1/swagger.json', 'Finpay API V1'
  else
    c.swagger_endpoint '/api-docs/v1/swagger.json', 'Finpay API V1'
  end
end

# Ensure rswag-api serves the static swagger file from the `swagger` folder
Rswag::Api.configure do |c|
  # Directory where Swagger JSON files are located
  if c.respond_to?(:openapi_root=)
    c.openapi_root = Rails.root.join('swagger').to_s
  else
    c.swagger_root = Rails.root.join('swagger').to_s
  end
end
