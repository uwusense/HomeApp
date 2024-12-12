class ChatRoomsController < ApplicationController
  before_action :set_chat_room, only: [:destroy]
  before_action :set_current_user_chat_rooms

  def index
    @selected_room = @chat_rooms.find(params[:chat_room_id]) if params[:chat_room_id]

    render 'index'
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @message = Message.new
    @messages = @chat_room.messages.order(created_at: :asc)

    render 'index'
  end

  def create
    service = ChatRoomService.new(current_user.id, params[:participant_id])
    result = service.find_or_create_chat_room
    chat_room = result[:chat_room]

    if chat_room
      notice_message = result[:found] ? 'Chat room already exists with this user' : 'Chat room created successfully'
      redirect_to chat_room_path(chat_room), notice: notice_message
    else
      Rails.logger.error "Chatroom failed to create: #{result[:error]}"
      redirect_to product_path(params[:product_id]), alert: 'Failed to create a chat room'
    end
  end

  def destroy
    if @chat_room.destroy
      respond_to do |format|
        format.html { redirect_to chat_rooms_path, notice: 'Chat room deleted successfully.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to chat_rooms_path, alert: 'Failed to delete chat room.' }
      end
    end
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def set_current_user_chat_rooms
    @chat_rooms = current_user.chat_rooms.includes(:messages).order(last_message_at: :desc)
  end
end
