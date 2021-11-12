class CreateDoAddonConnectorCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :do_addon_connector_customers do |t|
      t.integer :user_id
      t.string :key
      t.json :metadata

      t.timestamps
    end
    add_index :do_addon_connector_customers, :key
  end
end
