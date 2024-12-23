# == Schema Information
#
# Table name: messages
#
#  id           :bigint           not null, primary key
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_room_id :bigint           not null
#  user_id      :bigint           not null
#
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
