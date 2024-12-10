class ChatRoomsController < ApplicationController
  def index
    @chat_rooms = current_user.chat_rooms.includes(:messages)
    @selected_room = @chat_rooms.find(params[:chat_room_id]) if params[:chat_room_id]

    render 'index'
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @chat_rooms = current_user.chat_rooms.includes(:messages)
    @message = Message.new
    @messages = @chat_room.messages.order(created_at: :asc)

    render 'index'
  end

  def create
    service = ChatRoomService.new(current_user.id, params[:participant_id])
    chat_room = service.create_chat_room

    if chat_room.persisted?
      redirect_to chat_rooms_path(chat_room_id: chat_room.id), notice: 'Chat room created successfully'
    else
      redirect_to product_path(params[:product_id]), alert: 'Failed to create a chat room'
    end
  end
end
