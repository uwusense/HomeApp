class RemovePhotoUrlFromProductsAndTopicFromChatRooms < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :photo_url, :string
    remove_column :chat_rooms, :topic, :string
  end
end
