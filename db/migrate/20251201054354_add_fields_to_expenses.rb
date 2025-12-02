class AddFieldsToExpenses < ActiveRecord::Migration[7.1]
  def change
    # title and amount already exist, so DO NOT add them again

    add_column :expenses, :date, :date unless column_exists?(:expenses, :date)
    add_reference :expenses, :category, foreign_key: true unless column_exists?(:expenses, :category_id)
  end
end
