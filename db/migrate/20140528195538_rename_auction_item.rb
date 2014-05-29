class RenameAuctionItem < ActiveRecord::Migration
  def change
    remove_index :wow_auctions, :item
    rename_column :wow_auctions, :item, :blizz_item_id
    add_index :wow_auctions, :blizz_item_id
  end
end
