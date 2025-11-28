class RemoveCompanyIdFromEmployees < ActiveRecord::Migration[7.1]
  def change
    remove_column :employees, :company_id, :integer
  end
end
