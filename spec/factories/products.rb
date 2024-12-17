FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    price { Faker::Commerce.price(range: 10.0..1000.0) }
    description { Faker::Lorem.paragraph }
    category { 'doors_windows' }
    photo_url { Faker::Internet.url(host: 'example.com', path: '/image.jpg') }
    condition { %w[new used like_new].sample }
    association :user

    trait :new_condition do
      condition { 'new' }
    end

    trait :used_condition do
      condition { 'used' }
    end

    trait :like_new do
      condition { 'like_new' }
    end
  end
end
