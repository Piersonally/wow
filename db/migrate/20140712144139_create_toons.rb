class CreateToons < ActiveRecord::Migration
  def change
    create_table :wow_toons do |t|
      t.integer :user_id
      t.integer :realm_id
      t.string :name

      t.timestamps
    end

    add_index :wow_toons, :user_id
    add_index :wow_toons, :realm_id
    add_foreign_key :wow_toons, :users
    add_foreign_key :wow_toons, :wow_realms, column: :realm_id
  end
end
