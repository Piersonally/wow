require 'spec_helper'

describe Wow::Realm do
  describe "associations" do
    it { should have_many(:auctions).class_name(Wow::Auction) }
  end

  describe "validation" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
  end
end
