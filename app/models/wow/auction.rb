class Wow::Auction < ActiveRecord::Base
  self.table_name = 'wow_auctions'

  belongs_to :realm
  belongs_to :item, class_name: 'Wow::Item'

  before_destroy :clear_last_snapshot # See comment in method
  has_many :snapshots, class_name: 'Wow::AuctionSnapshot', dependent: :delete_all
  belongs_to :last_snapshot, class_name: 'Wow::AuctionSnapshot'

  validates :realm_id, :auction_house, presence: true
  validates :auc, :blizz_item_id, :owner, :owner_realm, :buyout, :quantity,
            presence: true

  def owner_name
    [owner_realm, owner].join '-'
  end

  def item_name
    item_id ? item.name : blizz_item_id
  end

  private

  def clear_last_snapshot
    # Must be called BEFORE has_many :snapshots, dependent: :delete_all
    # as :dependent is also implemented as a before_destroy callback and
    # will therefore get executed first.
    update_column :last_snapshot_id, nil
  end
end
