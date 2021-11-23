class CreateDoAddonConnectorTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :do_addon_connector_tokens do |t|
      t.integer :owner_id
      t.string :kind
      t.string :token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
