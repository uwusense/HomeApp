FactoryBot.define do
  factory :chat_room do
    association :creator, factory: :user
    association :participant, factory: :user
  end
end
