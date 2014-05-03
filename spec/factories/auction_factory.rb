# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auction, class: Wow::Auction do
    realm
    auc '12345678'
  end
end
