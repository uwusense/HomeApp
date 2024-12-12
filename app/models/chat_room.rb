class ChatRoom < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :participant, class_name: 'User', foreign_key: 'participant_id'

  after_update_commit { broadcast_latest_message }

  has_many :messages, dependent: :destroy

  broadcasts

  def target_person(current_user)
    current_user == creator ? participant : creator
  end

  def latest_message
    messages.includes(:user).order(created_at: :desc).first
  end

  def broadcast_latest_message
    last_message = latest_message
    return unless last_message

    target = "chat_room_#{id}_last_message"
    broadcast_update_to('chat_rooms',
      target: target,
      partial: 'chat_rooms/last_message',
      locals: { test_thing: "123", chat_room: self, last_message: last_message, user: last_message.user }
    )
  end
end
