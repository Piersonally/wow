module Wow
  class ItemLookupWorker
    include Sidekiq::Worker

    def perform
      in_progress_claims_without_items.each do |claim|
        ItemFetcher.new(claim.blizz_item_id).fetch
      end
    end

    private

    def in_progress_claims_without_items
      Wow::Auction.where(status: 'in_progress', item_id: nil).limit(5)
    end
  end
end
