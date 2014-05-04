require "spec_helper"

describe Wow::AuctionSyncher do

  describe "#sync_auctions" do
    let(:syncher) { Wow::AuctionSyncher.new realm }
    subject { syncher.sync_auctions }

    let(:auction_datafile_location_response) {
      {
        "files" => [
          {
            "url" => "http://us.battle.net/auction-data/e44ae1e38fefbe8d879d6af846d0014f/auctions.json",
            "lastModified" => auctions_last_modified.to_i * 1000
          }
        ]
      }.to_json
    }

    let(:auctions_last_modified) { 1.hour.ago }

    let!(:auction_datafile_location_request) do
      stub_request(:get, "http://us.battle.net/api/wow/auction/data/baelgun?locale=en_US").
        to_return(:status => 200, :body => auction_datafile_location_response, :headers => {})
    end

    let(:auction_data_response) { IO.read fixture_file_path 'auction_data_baelgun.json' }

    let!(:auction_data_request) do
      stub_request(:get, 'http://us.battle.net/auction-data/e44ae1e38fefbe8d879d6af846d0014f/auctions.json').
        to_return(:status => 200, :body => auction_data_response, :headers => {})
    end

    context "for a disabled realm" do
      let(:realm) { create :disabled_realm }

      it { expect { subject }.to raise_error RuntimeError }

      it "doesn't attempt to download data" do
        subject rescue nil;
        expect(auction_datafile_location_request).not_to have_been_made
      end

      it "doesn't create any auctions" do
        expect { subject rescue nil }.not_to change(Wow::Auction, :count)
      end

      it "doesn't update the realm's last_checked_at" do
        expect { subject rescue nil }.not_to change(realm, :last_checked_at)
      end
    end

    context "for an enabled Realm" do
      let!(:realm) { create :enabled_realm, slug: 'baelgun' }

      it "updates the realm's last_checked_at" do
        realm.update last_checked_at: 1.hour.ago
        subject
        expect(realm.last_checked_at).to be_within(5.seconds).of(Time.now)
      end

      it "locates the auction data for the realm" do
        subject
        expect(auction_datafile_location_request).to have_been_made.once
      end

      context "if the auction data lastModifed is the same as the realm last-synced_at"  do
        before { realm.update last_synced_at: auctions_last_modified }

        it "doesn't download auction data" do
          subject
          expect(auction_data_request).not_to have_been_made
        end

        it "doesn't create auctions" do
          expect { subject }.not_to change(Wow::Auction, :count)
        end

        it "doesn't update the realm last_synced_at" do
          expect { subject }.not_to change(realm, :last_synced_at)
        end

        it "updates the realm's last_checked_at" do
          realm.update last_checked_at: 1.hour.ago
          subject
          expect(realm.last_checked_at).to be_within(5.seconds).of(Time.now)
        end
      end

      context "if the auction data lastModifed is not the same as the realm last-synced_at"  do
        before { realm.update last_synced_at: 2.hours.ago }

        it "retrieves the auction data" do
          subject
          expect(auction_data_request).to have_been_made.once
        end

        it "updates the realm last_synced_at" do
          expect { subject }.to change { realm.last_synced_at.to_i }.to(auctions_last_modified.to_i)
        end

        context "when we have no seen any of the auctions before" do
          it "creates new auctions and auction snapshots" do
            expect {
              expect {
                subject
              }.to change(Wow::Auction, :count).by(3)
            }.to change(Wow::AuctionSnapshot, :count).by(3)
          end
        end

        context "when we have seen one of the auctions before" do
          let!(:auction) {
            realm.auctions.create!(
              auction_house: "horde", auc: 1991826120, item: 74248,
              owner: "Banzi", owner_realm: "Baelgun", buyout: 8750000,
              quantity: 5, rand: 0, seed: 1208009557
            )
          }

          it "doesn't duplicate the auction" do
            expect { subject }.to change(Wow::Auction, :count).by(2)
          end

          it "adds a snapshot to the existing auction" do
            expect { subject }.to change(auction.snapshots, :count).by(1)
          end
        end
      end
    end
  end
end
