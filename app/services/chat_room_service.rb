class ChatRoomService
  def initialize(creator_id, participant_id)
    @creator_id = creator_id
    @participant_id = participant_id
  end

  def create_chat_room
    chat_room = ChatRoom.create(
      creator_id: @creator_id,
      participant_id: @participant_id,
      draft: true
    )
    chat_room
  end
end
