module Wow
  class ItemFetcher

    def initialize(blizz_item_id)
      @blizz_item_id = blizz_item_id
    end

    def fetch
      item_data = fetch_item_data
      item = create_item item_data
      update_matching_auctions_to_point_to_item item
      item
    end

    private

    def fetch_item_data
      item_data = api.item @blizz_item_id

      unless @blizz_item_id.to_i == item_data['id'].to_i
        raise "Looking up item %d, got item %s: %s" % [
          @blizz_item_id.inspect, item_data['id'].inspect, item_data
        ]
      end
      item_data
    end

    def create_item(item_data)
      Wow::Item.create! blizz_item_id: item_data['id'],
                        name: item_data['name'],
                        data: item_data
    end

    def update_matching_auctions_to_point_to_item(item)
      Wow::Auction.where(blizz_item_id: @blizz_item_id).update_all item_id: item
    end

    def api
      @api ||= Wow::BattleNet::ApiClient.new
    end
  end
end
