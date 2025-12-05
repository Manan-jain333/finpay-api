class ChangeStatusToStringInExpenses < ActiveRecord::Migration[7.1]
  def change
    change_column :expenses, :status, :string
  end
end
