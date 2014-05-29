module Wow
  class AuctionSyncWorker
    include Sidekiq::Worker
    include Sidetiq::Schedulable

    recurrence { minutely 5 }

    def perform
      Wow::Realm.where(polling_enabled: true).each do |realm|
        Wow::AuctionSyncher.new(realm).sync_auctions
      end

      Wow::ItemLookupWorker.perform_in 1.minute
    end
  end
end
