class AddEmployeeToExpenses < ActiveRecord::Migration[7.1]
  def change
    # Remove old FK if exists
    remove_foreign_key :expenses, column: :employee_id rescue nil

    # Add correct FK referencing users table
    add_foreign_key :expenses, :users, column: :employee_id
  end
end
