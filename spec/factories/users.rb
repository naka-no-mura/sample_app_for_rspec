FactoryBot.define do
  factory :user do
    sequence(:email){|n| "test_#{n}@sample.com"}
    password { 'password' }
    password_confirmation { 'password' }
  end
end
