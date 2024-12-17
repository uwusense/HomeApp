class ChatRoomService
  def initialize(creator_id, participant_id)
    @creator_id = creator_id
    @participant_id = participant_id
  end

  def find_or_create_chat_room
    if @creator_id == @participant_id
      return { chat_room: nil, found: false, error: 'Cannot chat with yourself' }
    end

    chat_room = ChatRoom.find_by(
      '(creator_id = :creator AND participant_id = :participant) OR
       (creator_id = :participant AND participant_id = :creator)',
      creator: @creator_id,
      participant: @participant_id
    )

    return { chat_room: chat_room, found: true } if chat_room

    chat_room = ChatRoom.create(
      creator_id: @creator_id,
      participant_id: @participant_id,
      draft: true
    )

    if chat_room.persisted?
      { chat_room: chat_room, found: false }
    else
      { chat_room: nil, found: false, error: chat_room.errors.full_messages }
    end
  end
end
