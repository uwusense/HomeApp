class CreateChatRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_rooms do |t|
      t.string :topic
      t.boolean :draft
      t.timestamps
    end

    add_reference :chat_rooms, :creator, null: false, foreign_key: { to_table: :users }
    add_reference :chat_rooms, :participant, null: false, foreign_key: { to_table: :users }
  end
end
