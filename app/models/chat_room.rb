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
class ChatRoom < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :participant, class_name: 'User', foreign_key: 'participant_id'

  after_update_commit do
     broadcast_latest_message
     broadcast_draft_update
     broadcast_draft_message_update
  end

  has_many :messages, dependent: :destroy

  def target_person(current_user)
    current_user == creator ? participant : creator
  end

  def latest_message
    messages.includes(:user).order(created_at: :desc).first
  end

  # ajax update for partial - updates last message
  def broadcast_latest_message
    last_message = latest_message
    return unless last_message

    target = "chat_room_#{id}_last_message"
    broadcast_update_to('chat_rooms',
      target: target,
      partial: 'chat_rooms/last_message',
      locals: { chat_room: self, last_message: last_message, user: last_message.user }
    )
  end

  # ajax update for partial - removes draft indicator
  def broadcast_draft_update
    target = "chat_room_#{id}_draft"
    broadcast_update_to('chat_rooms',
      target: target,
      partial: 'chat_rooms/draft',
      locals: { chat_room: self }
    )
  end

  # ajax update for partial - removes draft info message
  def broadcast_draft_message_update
    target = "chat_room_#{id}_draft_message"
    broadcast_update_to('chat_rooms',
      target: target,
      partial: 'chat_rooms/draft_message',
      locals: { chat_room: self }
    )
  end
end
