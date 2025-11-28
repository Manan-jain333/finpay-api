class AddAgeToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :age, :integer
  end
end
