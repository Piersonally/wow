# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :realm_sync, class: Wow::RealmSync do
    realm
  end
end
