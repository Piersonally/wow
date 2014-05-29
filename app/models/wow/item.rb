module Wow
  class Item < ActiveRecord::Base
    self.table_name = 'wow_items'

    has_many :auctions, class_name: 'Wow::Auction', foreign_key: 'item_id'

    store :data, coder: JSON

    validates :blizz_item_id, :name, presence: true
  end
end
