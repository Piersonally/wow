class CreateWowAuctions < ActiveRecord::Migration
  def change
    create_table :wow_auctions do |t|
      t.integer :realm_id
      t.string :auction_house
      t.integer :item
      t.string :owner
      t.string :owner_realm
      t.integer :quantity
      t.integer :rand
      t.timestamps
    end

    add_column :wow_auctions, :auc, :bigint
    add_column :wow_auctions, :buyout, :bigint
    add_column :wow_auctions, :seed, :bigint

    add_index :wow_auctions, :realm_id
    add_index :wow_auctions, :auc
    add_index :wow_auctions, :item
    add_index :wow_auctions, [:owner, :owner_realm]
    add_foreign_key :wow_auctions, :wow_realms, column: :realm_id
  end
end
