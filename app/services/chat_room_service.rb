class ChatRoomService
  def initialize(creator_id, participant_id)
    @creator_id = creator_id
    @participant_id = participant_id
  end

  # rubocop:disable Style/HashSyntax
  def find_or_create_chat_room
    if @creator_id == @participant_id
      return { chat_room: nil, found: false, error: I18n.t(:chat_w_yourself, scope: 'flash') }
    end

    # We check if chatroom with these two context members already exist
    chat_room = ChatRoom.find_by(
      '(creator_id = :creator AND participant_id = :participant) OR
       (creator_id = :participant AND participant_id = :creator)',
      creator: @creator_id,
      participant: @participant_id
    )

    # if chatroom exists, we return it.
    return { chat_room: chat_room, found: true } if chat_room

    # else we create a new one.
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
  # rubocop:enable Style/HashSyntax
end
