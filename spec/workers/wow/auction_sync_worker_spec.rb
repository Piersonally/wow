require "spec_helper"

describe Wow::AuctionSyncWorker do
  let(:worker) { Wow::AuctionSyncWorker.new }
  subject { worker.perform }

  context "when there is only a disabled realm" do
    let!(:realm) { create :disabled_realm }

    it "should not do any syncing" do
      expect(Wow::AuctionSyncher).not_to receive :new
      subject
    end
  end

  context "when there are enabled  and disabled realms" do
    let!(:enabled_realm) { create :enabled_realm }
    let!(:disabled_realm) { create :disabled_realm }

    it "should sync the enabled realm" do
      mock_auction_syncher = double "auction syncher", sync_auctions: nil
      expect(Wow::AuctionSyncher).to receive(:new).with(enabled_realm).once
                                                  .and_return(mock_auction_syncher)
      subject
    end
  end
end
