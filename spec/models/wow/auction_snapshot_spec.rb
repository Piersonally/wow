require "spec_helper"

describe Wow::AuctionSnapshot do
  describe "associations" do
    it { should belong_to(:auction).class_name(Wow::Auction) }
    it { should belong_to(:realm_sync).class_name(Wow::RealmSync) }
  end

  describe "validation" do
    it { should validate_presence_of :auction_id }
    it { should validate_presence_of :bid }
    it { should validate_presence_of :time_left }
  end
end
