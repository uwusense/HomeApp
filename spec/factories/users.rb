# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string           not null
#  last_name              :string           not null
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#
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
