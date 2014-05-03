# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:name) { |n| "name#{n}" }

  factory :realm, class: Wow::Realm do
    name
    slug { |r| r.name }
  end
end
