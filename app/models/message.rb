class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  after_create_commit -> {
    broadcast_append_to chat_room
  }

  after_destroy_commit -> {
    broadcast_remove_to chat_room
  }

  after_create :update_chat_room

  def own?
    self.user == current_user
  end

  private

  def update_chat_room
    chat_room.touch
  end
end
