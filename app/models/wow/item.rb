module Wow
  class Item < ActiveRecord::Base
    self.table_name = 'wow_items'

    has_many :auctions, class_name: 'Wow::Auction', foreign_key: 'item_id'

    store :data, coder: JSON

    validates :blizz_item_id, :name, presence: true

    searchkick index_name: "#{Rails.application.class.parent_name.downcase}_#{model_name.plural}_#{Rails.env.to_s}"

    def search_data
      {
        name: name
      }
    end
  end
end
