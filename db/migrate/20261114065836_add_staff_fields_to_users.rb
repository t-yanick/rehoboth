class AddStaffFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :role, :string, null: false, default: "warehouse_staff"
    add_column :users, :locale, :string, null: false, default: "en"
    add_column :users, :active, :boolean, null: false, default: true
    add_index :users, :role
  end
end
