class AddLastMessageAtToChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chat_rooms, :last_message_at, :datetime
  end
end
