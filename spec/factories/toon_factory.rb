# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :toon, class: Wow::Toon do
    name
    association :realm
  end
end
