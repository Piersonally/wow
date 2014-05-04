module Wow
  class AuctionSyncher

    def initialize(realm)
      @realm = realm
    end

    def retrieve_and_import_auctions(options={})
      raise "realm is not enabled" unless @realm.polling_enabled?
      @houses_to_import = options[:auction_houses] || %w[ horde ]
      auction_datafile_location = locate_auction_datafile
      auctions_data = retrieve_auctions_data auction_datafile_location
      import_auctions auctions_data
    end

    private

    def locate_auction_datafile
      response = api_client.auctions_datafile_location_for_realm @realm.slug
      raise "There is more than 1 data file!" unless response['files'].size == 1
      response['files'].first['url']
    end

    def retrieve_auctions_data(data_location)
      json_string = Net::HTTP.get URI(data_location)
      JSON.parse json_string
    end

    def import_auctions(auctions_data)
      @houses_to_import.each do |house|
        import_auctions_for_house house, auctions_data[house]['auctions']
      end
    end

    def import_auctions_for_house(house, auctions)
      auctions.each do |auc_data|
        auction = @realm.auctions.find_by_auc auc_data['auc'].to_s
        unless auction
          auction = create_new_auction house, auc_data
        end
        create_snapshot_of_auction auction, auc_data
      end
    end
    
    def create_new_auction(house, auction_data)
      @realm.auctions.create!(
        auction_house: house,
        auc:           auction_data['auc'],
        item:          auction_data['item'],
        owner:         auction_data['owner'],
        owner_realm:   auction_data['ownerRealm'],
        buyout:        auction_data['buyout'],
        quantity:      auction_data['quantity'],
        rand:          auction_data['rand'],
        seed:          auction_data['seed']
      )
    end

    def create_snapshot_of_auction(auction, auction_data)
      auction.snapshots.create!(
        bid:       auction_data['bid'],
        time_left: auction_data['timeLeft']
      )
    end

    def api_client
      @api_client ||= BattleNet::ApiClient.new
    end
  end
end
