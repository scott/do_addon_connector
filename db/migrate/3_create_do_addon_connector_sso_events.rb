class CreateDoAddonConnectorSsoEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :do_addon_connector_sso_events, id: :uuid do |t|
      t.string :resource_uuid
      t.string :resource_token
      t.integer :timestamp
      t.string :email
      t.integer :owner_id

      t.timestamps
    end
    add_index :do_addon_connector_sso_events, :email

  end
end
