class CreateReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :receipts do |t|
      t.string :file_url
      t.references :expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
