class CreateWowItems < ActiveRecord::Migration
  def change
    create_table :wow_items do |t|
      t.integer :blizz_item_id
      t.string :name
      t.string :description
      t.text :data

      t.timestamps
    end

    add_index :wow_items, :blizz_item_id

    add_column :wow_auctions, :item_id, :integer
    add_index :wow_auctions, :item_id
  end
end
