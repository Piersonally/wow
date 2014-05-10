class CreateRealmSyncs < ActiveRecord::Migration
  def change
    create_table :wow_realm_syncs do |t|
      t.integer :realm_id

      t.timestamps
    end

    add_index :wow_realm_syncs, :realm_id
    add_foreign_key :wow_realm_syncs, :wow_realms, column: 'realm_id'
    add_index :wow_realm_syncs, :created_at

    add_column :wow_auction_snapshots, :realm_sync_id, :integer
    add_index :wow_auction_snapshots, :realm_sync_id
    add_foreign_key :wow_auction_snapshots, :wow_realm_syncs, column: 'realm_sync_id'
  end
end
