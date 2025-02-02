# == Schema Information
#
# Table name: products
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  price        :decimal(10, 2)   not null
#  description  :string           not null
#  category     :string           not null
#  condition    :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  listing_type :string           default("sell"), not null
#
FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    price { Faker::Commerce.price(range: 10.0..1000.0) }
    description { Faker::Lorem.paragraph }
    category { 'doors_windows' }
    condition { %w[new used like_new].sample }
    association :user
  end
end
