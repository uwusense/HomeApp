class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [:destroy]
  before_action :set_current_user_chat_rooms

  def index
    @chat_room = @chat_rooms.find(params[:chat_room_id]) if params[:chat_room_id]

    render 'index'
  end

  def show
    @chat_room = current_user.chat_rooms.find(params[:id])
    @message = Message.new
    @messages = @chat_room.messages.order(created_at: :asc)
    render 'index'

  rescue ActiveRecord::RecordNotFound
    flash[:error] = t(:chat_room_not_found, scope: 'flash')
    render 'index'
  end

  def create
    service = ChatRoomService.new(current_user.id, params[:participant_id].to_i)
    result = service.find_or_create_chat_room
    chat_room = result[:chat_room]

    if chat_room
      notice_message = result[:found] ? t(:existing_chat_room, scope: 'chats') : t(:new_chat_room, scope: 'chats')
      redirect_to chat_room_path(chat_room), notice: notice_message
    else
      Rails.logger.error "Chatroom failed to create: #{result[:error]}"
      redirect_to catalog_path(params[:product_id]), alert: t(:failed_chat_room, scope: 'flash')
    end
  end

  def destroy
    if current_user == @chat_room.participant || current_user == @chat_room.creator
      if @chat_room.destroy
        respond_to do |format|
          format.html { redirect_to chat_rooms_path, notice: t(:ok_delete_chat_room, scope: 'flash') }
        end
      else
        respond_to do |format|
          format.html { redirect_to chat_rooms_path, alert: t(:failed_delete_chat_room, scope: 'flash') }
        end
      end
    else
      flash[:alert] = t(:unexpected, scope: 'flash')
      redirect_to root_path
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
