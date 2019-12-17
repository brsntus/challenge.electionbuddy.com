class CreateAudits < ActiveRecord::Migration[6.0]
  def change
    create_table :audits do |t|
      t.string :auditable_type, null: false
      t.integer :auditable_id, null: false
      t.references :user, null: false, foreign_key: true
      t.json :audit_changes, null: false
      t.string :audit_type, null: false

      t.timestamps
    end

    add_index :audits, [:auditable_type, :auditable_id]
  end
end
