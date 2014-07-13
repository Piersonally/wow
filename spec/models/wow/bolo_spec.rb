require "spec_helper"

describe Wow::Bolo do
  describe "associations" do
    it { should belong_to(:watcher).class_name('User') }
    it { should belong_to(:item).class_name('Wow::Item') }
    it { should belong_to(:found_auction).class_name('Wow::Auction') }
  end

  describe "validation" do
    it { should validate_presence_of :watcher_id }
    it { should validate_presence_of :item_id }
  end
end
