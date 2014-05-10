require "spec_helper"

describe Wow::RealmSync do
  describe "associations" do
    it { should belong_to :realm }
    it { should have_many :auction_snapshots }
  end
end
