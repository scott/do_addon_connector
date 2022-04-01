class AddCreatorIdToDoAddonConnectorCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :do_addon_connector_customers, :creator_id, :string
  end
end