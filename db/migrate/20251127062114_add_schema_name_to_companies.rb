class AddSchemaNameToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :schema_name, :string
  end
end
