class AddPollingEnabledToWowRealms < ActiveRecord::Migration
  def change
    add_column :wow_realms, :polling_enabled, :boolean, default: 'f'
    add_index :wow_realms, :polling_enabled
  end
end
