class UniqueIndexInItemBlizzId < ActiveRecord::Migration
  def change
    remove_index :wow_items, :blizz_item_id
    add_index :wow_items, :blizz_item_id, unique: true
    add_foreign_key :wow_auctions, :wow_items, column: 'item_id'
  end
end
