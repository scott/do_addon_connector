class AddCreatorIdToDoAddonConnectorCustomers < ActiveRecord::Migration
  def change
    add_column :do_addon_connector_customers, :creator_id, :string
  end
end