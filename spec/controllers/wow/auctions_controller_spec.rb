require 'spec_helper'

describe Wow::AuctionsController do
  let!(:realm) { create :realm }
  let!(:auction) { create :auction }

  let(:valid_auction_params) {
    { realm_id: realm.to_param, auction_house: 'horde', auc: '1991857830',
      item: '55714', owner: 'Penloh', owner_realm: 'Baelgun', buyout: '1826700',
      quantity: '1', rand: '-6', seed: '2094399793' }.with_indifferent_access
  }
  let(:invalid_auction_params) {
    { realm_id: nil }.with_indifferent_access
  }

  describe "GET index" do
    it "assigns all auctions as @auctions" do
      get :index
      expect(assigns :auctions).to eq [auction]
    end
  end

  describe "GET show" do
    it "assigns the requested auction as @auction" do
      get :show, id: auction.to_param
      expect(assigns :auction).to eq auction
    end
  end

  describe "GET new" do
    it "assigns a new auction as @auction" do
      get :new
      expect(assigns :auction).to be_a_new Wow::Auction
    end
  end

  describe "GET edit" do
    it "assigns the requested auction as @auction" do
      get :edit, id: auction.to_param
      expect(assigns :auction).to eq auction
    end
  end

  describe "POST create" do
    subject { post :create, auction: auction_params }

    describe "with valid params" do
      let(:auction_params) { valid_auction_params }

      it { expect { subject }.to change(Wow::Auction, :count).by(1) }

      describe "and" do
        before { subject }
        it { expect(assigns :auction).to be_a Wow::Auction }
        it { expect(assigns :auction).to be_persisted }
      end

      it "redirects to the created auction" do
        subject
        expect(response).to redirect_to Wow::Auction.last
      end
    end

    describe "with invalid params" do
      let(:auction_params) { invalid_auction_params }
      before { subject }

      it { expect(assigns :auction).to be_a_new Wow::Auction }
      it { expect(response).to render_template 'new' }
    end
  end

  describe "PATCH update" do
    subject { patch :update, id: auction.id, auction: auction_params }

    describe "with valid params" do
      let(:auction_params) { valid_auction_params }

      it "updates the requested auction" do
        allow(Wow::Auction).to receive(:find).and_return(auction)
        expect(auction).to receive(:update).with(auction_params)
        subject
      end

      describe "and" do
        before { subject }

        it { expect(assigns :auction).to eq auction }
        it { expect(response).to redirect_to auction }
      end
    end

    describe "with invalid params" do
      let(:auction_params) { invalid_auction_params }
      before { subject }

      it { expect(assigns :auction).to eq auction }
      it { expect(response).to render_template 'edit' }
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, id: auction.to_param }

    it "destroys the requested auction" do
      expect {
        subject
      }.to change(Wow::Auction, :count).by(-1)
    end

    it "redirects to the auctions list" do
      subject
      expect(response).to redirect_to wow_auctions_url
    end
  end
end

