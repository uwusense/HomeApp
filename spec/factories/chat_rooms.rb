# == Schema Information
#
# Table name: chat_rooms
#
#  id              :bigint           not null, primary key
#  draft           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :bigint           not null
#  participant_id  :bigint           not null
#  last_message_at :datetime
#
FactoryBot.define do
  factory :chat_room do
    association :creator, factory: :user
    association :participant, factory: :user
  end
end
