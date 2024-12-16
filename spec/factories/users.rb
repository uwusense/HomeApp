FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { 'first_name' }
    last_name { 'last_name' }
    username { 'Test_username' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
