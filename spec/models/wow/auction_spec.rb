require 'spec_helper'

describe Wow::Auction do
  describe "associations" do
    it { should belong_to(:realm).class_name(Wow::Realm) }
  end
end
