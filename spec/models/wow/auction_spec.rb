require 'spec_helper'

describe Wow::Auction do
  describe "associations" do
    it { should belong_to(:realm).class_name(Wow::Realm) }
    it { should have_many(:snapshots).class_name(Wow::AuctionSnapshot) }
  end
end
