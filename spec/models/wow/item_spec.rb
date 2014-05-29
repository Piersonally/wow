require "spec_helper"

describe Wow::Item do
  describe "associations" do
    it { should have_many(:auctions).class_name('Wow::Auction').with_foreign_key('item_id') }
  end

  describe "validation" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :blizz_item_id }
  end
end
