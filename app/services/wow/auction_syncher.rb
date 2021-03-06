module Wow

  class AuctionSyncher

    def initialize(realm, options={})
      @realm = realm
      @houses_to_import = options[:auction_houses] || %w[ horde ]
      @auctions_file = Wow::BlizzAuctionsFile.new @realm
      @stats = {
        auctions_created: 0,
        snapshots_created: 0,
        auctions_sold: 0,
        auctions_expired: 0
      }
    end

    def sync_auctions
      log "starting"
      raise "realm is not enabled" unless @realm.polling_enabled?
      if there_are_new_auctions_to_download?
        retrieve_and_synchronize_auctions_with_logging
      else
        log_that_we_are_skipping_this_realm
      end
    end

    private

    include Logging

    EVENT_CODE = 'com.piersonally.wow.AuctionSyncher'

    def log_with_less_args(message, options={})
      log_without_less_args EVENT_CODE, message, options
    end
    alias_method_chain :log, :less_args

    def there_are_new_auctions_to_download?
      @realm.update last_checked_at: Time.now
      @auctions_file.last_modified_at.to_i != @realm.last_synced_at.to_i
    end

    def log_that_we_are_skipping_this_realm
      message = "skipping %s, auctions file update time is still %d" %
        [@realm.name, @realm.last_synced_at.to_i]
      log message, publish: true, log_level: :debug
    end

    def catching_normal_errors(&block)
      begin
        yield
      rescue JSON::ParserError => e
        if e.message =~ /auctions.json was not found on this server/
          # Blizzard's auction data server doesn't give a 404 for unknown files.
          # Instead you get an HTML page back that looks something like this:
          #   <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN"> <html><head>
          #   <title>404 Not Found</title> </head><body> <h1>Not Found</h1>
          #   <p>The requested URL /auction-data/9c2f17f8b6a70f0347c5f1145145175d/auctions.json
          #   was not found on this server.</p> </body></html>
          log "404: #{@auctions_file.file_location}", publish: true, log_level: :alert
        else
          raise
        end
      end
    end

    def retrieve_and_synchronize_auctions_with_logging
      catching_normal_errors do
        log_synch_start
        retrieve_and_synchronize_auctions
        log_sync_end
      end
    end

    def retrieve_and_synchronize_auctions
      auctions_data = retrieve_auctions
      synchronize_auctions auctions_data
    end

    def retrieve_auctions
      @auctions_file.retrieve_auction_data
    end

    def synchronize_auctions(auctions_data)
      Wow::Auction.transaction do
        import_auctions auctions_data
        @realm.update last_synced_at: @auctions_file.last_modified_at
      end
    end

    def log_synch_start
      @start_time = Time.now
      log "Synching %s %d at %s" %
        [@realm.name, @auctions_file.last_modified_at.to_i, @start_time]
    end

    def log_sync_end
      elapsed_time = Time.now - @start_time
      message = ("Synched %s %d in %.1fs. " +
          "Auctions: %d new, %d sold, %d expired, (%d snapshots).") %
        [
          @realm.name,
          @auctions_file.last_modified_at.to_i,
          elapsed_time,
          @stats[:auctions_created],
          @stats[:auctions_sold],
          @stats[:auctions_expired],
          @stats[:snapshots_created]
        ]
      log message, publish: true, log_level: :info
    end

    def import_auctions(auctions_data)
      find_ids_of_auctions_seen_during_last_sync
      @sync = @realm.realm_syncs.create!
      @houses_to_import.each do |house|
        import_auctions_for_house house, auctions_data[house]['auctions']
      end
      mark_missing_auctions_as_completed
    end

    def import_auctions_for_house(house, auctions)
      auctions.each do |auc_data|
        auction = @realm.auctions.find_by_auc auc_data['auc'].to_s
        if auction
          remove_auction_from_missing_list auction
        else
          auction = create_new_auction house, auc_data
        end
        create_snapshot_of_auction auction, auc_data
      end
    end
    
    def create_new_auction(house, auction_data)
      @stats[:auctions_created] += 1
      item = Wow::Item.find_by_blizz_item_id auction_data['item']
      auction_attrs = {
        auction_house: house,
        auc:           auction_data['auc'],
        blizz_item_id: auction_data['item'],
        owner:         auction_data['owner'],
        owner_realm:   auction_data['ownerRealm'],
        buyout:        auction_data['buyout'],
        quantity:      auction_data['quantity'],
        rand:          auction_data['rand'],
        seed:          auction_data['seed'],
      }
      auction_attrs[:item_id] = item.id if item
      @realm.auctions.create! auction_attrs
    end

    def create_snapshot_of_auction(auction, auction_data)
      @stats[:snapshots_created] += 1
      snapshot = auction.snapshots.create!(
        realm_sync: @sync,
        bid:        auction_data['bid'],
        time_left:  auction_data['timeLeft']
      )
      auction.update! last_snapshot: snapshot
    end

    concerning :TrackingAuctionsThatHaveDisappeared do

      def find_ids_of_auctions_seen_during_last_sync
        last_sync = @realm.realm_syncs.order(:created_at).last
        if last_sync
          Rails.logger.info "AuctionSyncher: comparing against RealmSync #{last_sync.id}"
          @missing_auction_ids = Wow::Auction.joins(:snapshots => :realm_sync)
                                   .where("wow_realm_syncs.id = ?", last_sync.id)
                                   .pluck(:id)
        else
          @missing_auction_ids = []
        end
      end

      def remove_auction_from_missing_list(auction)
        @missing_auction_ids.delete auction.id
      end

      def mark_missing_auctions_as_completed
        return if @missing_auction_ids.empty?

        Wow::Auction.where(id: @missing_auction_ids).find_each do |auction|
          last_snapshot = auction.snapshots.last
           if %[SHORT MEDIUM].include? last_snapshot.time_left
             auction.update! status: 'expired'
             @stats[:auctions_expired] += 1
           else
             auction.update! status: 'sold'
             @stats[:auctions_sold] += 1
           end
        end
      end
    end
  end
end
