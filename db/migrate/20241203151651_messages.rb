class Messages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.timestamps
    end

    add_reference :messages, :chat_room, null: false, foreign_key: { to_table: :chat_rooms }
    add_reference :messages, :user, null: false, foreign_key: { to_table: :users }
  end
end
