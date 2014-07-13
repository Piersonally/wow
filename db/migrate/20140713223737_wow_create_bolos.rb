class WowCreateBolos < ActiveRecord::Migration
  def change
    create_table :wow_bolos do |t|
      t.integer :watcher_id
      t.integer :item_id
      t.integer :found_auction_id

      t.timestamps
    end

    add_index :wow_bolos, :watcher_id
    add_index :wow_bolos, :item_id
    add_index :wow_bolos, :found_auction_id
    add_foreign_key :wow_bolos, :users, column: 'watcher_id'
    add_foreign_key :wow_bolos, :wow_items, column: 'item_id'
    add_foreign_key :wow_bolos, :wow_auctions, column: 'found_auction_id'
  end
end
