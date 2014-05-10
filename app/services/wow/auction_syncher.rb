module Wow

  class AuctionSyncher

    def initialize(realm, options={})
      @realm = realm
      @houses_to_import = options[:auction_houses] || %w[ horde ]
    end

    def sync_auctions
      raise "realm is not enabled" unless @realm.polling_enabled?
      @realm.update last_checked_at: Time.now
      auctions_file = Wow::BlizzAuctionsFile.new @realm
      if auctions_file.last_modified_at.to_i == @realm.last_synced_at.to_i
        Rails.logger.info "AuctionSyncher: skipping #{@realm.name}, auctions file update time is still #{@realm.last_synced_at.to_i}"
      else
        retrieve_and_import_auctions auctions_file
      end
    end

    private

    def retrieve_and_import_auctions(auctions_file)
      log_start auctions_file
      auctions_data = auctions_file.retrieve_auction_data
      Wow::Auction.transaction do
        @sync = @realm.realm_syncs.create!
        import_auctions auctions_data
        @realm.update last_synced_at: auctions_file.last_modified_at
      end
      log_end auctions_file
    end

    def log_start(auctions_file)
      @start_time = Time.now
      Rails.logger.info "AuctionSyncher: starting synch of %s %d at %s" %
                          [@realm.name, auctions_file.last_modified_at.to_i, @start_time]
    end

    def log_end(auctions_file)
      elapsed_time = Time.now - @start_time
      Rails.logger.info "AuctionSyncher: completed synch of %s %d in %.1fs. %d auctions and %d snapshots created." %
        [
          @realm.name, auctions_file.last_modified_at.to_i, elapsed_time,
          @stats[:new_auctions_count], @stats[:snapshots_created_count]
        ]
    end

    def import_auctions(auctions_data)
      @stats = {new_auctions_count: 0, snapshots_created_count: 0}
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
      @stats[:new_auctions_count] += 1
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
      @stats[:snapshots_created_count] += 1
      auction.snapshots.create!(
        realm_sync: @sync,
        bid:        auction_data['bid'],
        time_left:  auction_data['timeLeft']
      )
    end
  end
end
