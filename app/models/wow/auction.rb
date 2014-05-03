class Wow::Auction < ActiveRecord::Base
  self.table_name = 'wow_auctions'

  belongs_to :realm
  has_many :snapshots, class_name: 'Wow::AuctionSnapshot'

  validates :realm_id, presence: true

  def owner_name
    [owner_realm, owner].join '-'
  end
end
