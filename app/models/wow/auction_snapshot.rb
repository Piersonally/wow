module Wow
  class AuctionSnapshot < ActiveRecord::Base
    self.table_name = 'wow_auction_snapshots'

    belongs_to :auction
    belongs_to :realm_sync

    validates :auction_id, :realm_sync_id,
              :bid, :time_left, presence: true
  end
end
