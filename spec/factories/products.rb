FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    price { Faker::Commerce.price(range: 10.0..1000.0) }
    description { Faker::Lorem.paragraph }
    category { 'doors_windows' }
    photo_url { Faker::Internet.url(host: 'example.com', path: '/image.jpg') }
    condition { %w[new used like_new].sample }
    association :user
  end
end
