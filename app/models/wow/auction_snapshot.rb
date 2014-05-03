class Wow::AuctionSnapshot < ActiveRecord::Base
  self.table_name = 'wow_auction_snapshots'

  belongs_to :auction

  validates :auction_id, :bid, :time_left, presence: true
end
