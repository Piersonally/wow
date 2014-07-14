# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bolo, class: Wow::Bolo do
    association :watcher, factory: :user
    association :item
  end
end
