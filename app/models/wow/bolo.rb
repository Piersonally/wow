module Wow
  class Bolo < ActiveRecord::Base
    self.table_name = 'wow_bolos'

    belongs_to :watcher, class_name: 'User'
    belongs_to :item, class_name: 'Wow::Item'
    belongs_to :found_auction, class_name: 'Wow::Auction'

    validates :watcher_id, :item_id, presence: true
  end
end
