class Auc < ActiveRecord::Base
  self.table_name = 'wow_auctions'
  has_many :snapshots, class_name: 'Snapshot', foreign_key: 'auction_id'
end

class Snapshot < ActiveRecord::Base
  self.table_name = 'wow_auction_snapshots'
end

def update_auctions_with_latest_snapshot_id
  STDOUT.sync = true
  puts "Updating auctions:"
  count = 0
  last_announce = Time.now
  Auc.find_each do |a|
    count += 1
    last_ss = a.snapshots.last
    a.update_column :last_snapshot_id, last_ss.id
    if (Time.now - last_announce) > 2.0
      STDOUT << "\r#{count}"
      last_announce = Time.now
    end
  end
  puts "\n"
end

class AddLastSnapshotToAuctions < ActiveRecord::Migration
  def up
    add_column :wow_auctions, :last_snapshot_id, :integer
    update_auctions_with_latest_snapshot_id
    add_index :wow_auctions, :last_snapshot_id
    add_foreign_key :wow_auctions, :wow_auction_snapshots, column: 'last_snapshot_id'
  end

  def down
    remove_column :wow_auctions, :last_snapshot_id
  end
end
