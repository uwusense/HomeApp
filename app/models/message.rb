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
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  after_create_commit -> {
    update_parent_room
    broadcast_append_to chat_room
  }

  after_destroy_commit -> {
    broadcast_remove_to chat_room
  }

  def own?
    self.user == current_user
  end

  def update_parent_room
    chat_room.update(last_message_at: Time.now)
    if chat_room.messages.count > 0
      chat_room.update(draft: false)
    end
  end
end
