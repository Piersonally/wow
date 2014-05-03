class CreateWowAuctions < ActiveRecord::Migration
  def change
    create_table :wow_auctions do |t|
      t.integer :realm_id
      t.string :auction_house
      t.string :auc
      t.integer :item
      t.string :owner
      t.string :owner_realm
      t.integer :buyout
      t.integer :quantity
      t.integer :rand
      t.integer :seed

      t.timestamps
    end

    add_index :wow_auctions, :realm_id
    add_index :wow_auctions, :auc
    add_index :wow_auctions, :item
    add_index :wow_auctions, [:owner, :owner_realm]
    add_foreign_key :wow_auctions, :wow_realms, column: :realm_id
  end
end
