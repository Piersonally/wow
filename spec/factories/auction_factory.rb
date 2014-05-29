# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auction, class: Wow::Auction do
    realm
    auction_house 'horde'
    auc '12345678'
    blizz_item_id '12345'
    owner 'Sometoon'
    owner_realm 'Somerealm'
    buyout 2500000
    quantity 1
    rand "1234567890"
    seed "1234567890"
  end
end
