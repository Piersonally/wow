module Wow

  class BlizzAuctionsFile

    def initialize(realm)
      @realm = realm
    end

    def last_modified_at
      Time.at metadata['files'].first['lastModified'] / 1000
    end

    def retrieve_auction_data
      json_string = Net::HTTP.get URI(file_location)
      JSON.parse json_string
    end

    private

    def file_location
      metadata['files'].first['url']
    end

    def metadata
      @metadata ||= retrieve_metadata
    end

    def retrieve_metadata
      response = api_client.auctions_datafile_location_for_realm @realm.slug
      raise "There is more than 1 data file!" unless response['files'].size == 1
      response
    end

    def api_client
      @api_client ||= BattleNet::ApiClient.new
    end
  end


  class AuctionSyncher

    def initialize(realm, options={})
      @realm = realm
      @houses_to_import = options[:auction_houses] || %w[ horde ]
    end

    def sync_auctions
      raise "realm is not enabled" unless @realm.polling_enabled?
      auctions_file = BlizzAuctionsFile.new @realm
      if auctions_file.last_modified_at.to_i != @realm.last_synced_at.to_i
        retrieve_and_import_auctions auctions_file
      end
    end

    private

    def retrieve_and_import_auctions(auctions_file)
      auctions_data = auctions_file.retrieve_auction_data
      Wow::Auction.transaction do
        import_auctions auctions_data
        @realm.update last_checked_at: Time.now,
                      last_synced_at: auctions_file.last_modified_at
      end
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
  end
end
