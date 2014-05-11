# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auction_snapshot, class: Wow::AuctionSnapshot do
    auction
    realm_sync
    bid 1
    time_left "LONG"
  end
end
