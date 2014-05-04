require "spec_helper"

describe Wow::AuctionSyncher do

  describe "#retrieve_and_import_auctions" do
    let(:syncher) { Wow::AuctionSyncher.new realm }
    subject { syncher.retrieve_and_import_auctions realm }

    let(:auction_datafile_location_response) {
      '{"files":[{"url":"http://us.battle.net/auction-data/e44ae1e38fefbe8d879d6af846d0014f/auctions.json","lastModified":1399151636000}]}'
    }
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

      it "should not attempt to download data" do
        subject rescue nil;
        expect(auction_datafile_location_request).not_to have_been_made
      end

      it "should not create any auctions" do
        expect { subject rescue nil }.not_to change(Wow::Auction, :count)
      end
    end

    context "for an enabled Realm" do
      let!(:realm) { create :enabled_realm, slug: 'baelgun' }

      it "locates the auction data for the realm" do
        subject
        expect(auction_datafile_location_request).to have_been_made.once
      end

      it "retrieves the auction data" do
        subject
        expect(auction_data_request).to have_been_made.once
      end

      context "when we have no seen any of the auctions before" do
        it "should create new auctions and auction snapshots" do
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

        it "should not duplicate the auction" do
          expect { subject }.to change(Wow::Auction, :count).by(2)
        end

        it "should add a snapshot to the existing auction" do
          expect { subject }.to change(auction.snapshots, :count).by(1)
        end
      end
    end
  end
end
