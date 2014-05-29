module Wow
  class ItemLookupWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform
      @items_created_count = 0
      blizz_item_ids_for_in_progress_auctions.each do |blizz_item_id|
        ItemFetcher.new(blizz_item_id).fetch
        @items_created_count += 1
      end
      Rails.logger.info "ItemLookupWorker: created %d items" % [@items_created_count]
    end

    private

    def blizz_item_ids_for_in_progress_auctions
      Wow::Auction.connection.select_values(
        "SELECT DISTINCT(blizz_item_id) FROM wow_auctions
        WHERE status = 'in_progress' AND item_id IS NULL"
      )
    end
  end
end
