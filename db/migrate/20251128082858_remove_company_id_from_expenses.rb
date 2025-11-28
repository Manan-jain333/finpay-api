class RemoveCompanyIdFromExpenses < ActiveRecord::Migration[7.1]
  def change
    remove_column :expenses, :company_id, :bigint
  end
end
