module Wow
  class AuctionSyncWorker
    include Sidekiq::Worker
    include Sidetiq::Schedulable

    recurrence { minutely 5 }

    def perform
      Wow::Realm.where(polling_enabled: true).each do |realm|
        Wow::AuctionSyncher.new(realm).sync_auctions
      end
    end
  end
end
