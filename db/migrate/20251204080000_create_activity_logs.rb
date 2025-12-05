class CreateActivityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_logs do |t|
      t.string :action, null: false
      t.string :record_type
      t.bigint :record_id
      t.references :user, foreign_key: true, index: true
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :activity_logs, [:record_type, :record_id]
  end
end
