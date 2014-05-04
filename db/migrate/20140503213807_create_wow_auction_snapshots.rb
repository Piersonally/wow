class CreateWowAuctionSnapshots < ActiveRecord::Migration
  def change
    create_table :wow_auction_snapshots do |t|
      t.integer :auction_id
      t.string :time_left
      t.timestamps
    end
    add_column :wow_auction_snapshots, :bid, :bigint

    add_index :wow_auction_snapshots, :auction_id
    add_foreign_key :wow_auction_snapshots, :wow_auctions, column: 'auction_id'
  end
end
