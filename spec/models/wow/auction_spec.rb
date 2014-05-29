require 'spec_helper'

describe Wow::Auction do
  describe "associations" do
    it { should belong_to(:realm).class_name(Wow::Realm) }
    it { should have_many(:snapshots).class_name(Wow::AuctionSnapshot) }
  end

  describe "validations" do
    it { should validate_presence_of :realm_id }
    it { should validate_presence_of :auction_house }
    it { should validate_presence_of :auc }
    it { should validate_presence_of :blizz_item_id }
    it { should validate_presence_of :owner }
    it { should validate_presence_of :owner_realm }
    it { should validate_presence_of :buyout }
    it { should validate_presence_of :quantity }
  end
end
