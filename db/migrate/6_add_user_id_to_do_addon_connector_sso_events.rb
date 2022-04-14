class AddUserIdToDoAddonConnectorSsoEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :do_addon_connector_sso_events, :user_id, :string
  end
end