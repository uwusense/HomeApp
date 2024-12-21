FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { 'first_name' }
    last_name { 'last_name' }
    username { Faker::Internet.unique.username }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      admin { true }
    end

    after(:create) do |user|
      user.wallet.update(balance: 10000.00)
    end
  end
end
