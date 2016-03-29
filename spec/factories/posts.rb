# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    content { Forgery('lorem_ipsum').sentence }
    association :user, factory: :user, strategy: :build
  end
end
