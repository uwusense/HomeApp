FactoryBot.define do
  factory :message do
    association :chat_room
    body { "Test message" }
    user { chat_room.creator }

    trait :from_creator do
      user { chat_room.creator }
    end

    trait :from_participant do
      user { chat_room.participant }
    end
  end
end
