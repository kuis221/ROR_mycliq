# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name { Forgery::Name.first_name }
    sequence(:username) { |n| "uniq_code#{n}" }
    sequence(:email) { |n| "emaqqq#{n}@factory.com" }
    password "12345678"
    password_confirmation { |u| u.password }
  end
end
