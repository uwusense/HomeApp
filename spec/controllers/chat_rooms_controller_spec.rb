require 'rails_helper'

RSpec.describe ChatRoomsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    let!(:chat_room) { create(:chat_room, creator: user, participant: other_user) }

    before { sign_in user }

    it 'assigns @chat_room' do
      get :index, params: { chat_room_id: chat_room.id }
      expect(assigns(:chat_room)).to eq(chat_room)
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'when successfuly creates a chatroom' do
      it 'redirects to chat room with flash' do
        expect {
          post :create, params: { participant_id: other_user.id }
        }.to change(ChatRoom, :count).by(1)
        expect(response).to redirect_to(chat_room_path(ChatRoom.last.id))
        expect(flash[:notice]).to eq('Chat room created successfully')
      end
    end

    context 'when creation of chat room fails' do
      let(:product) { create(:product)}

      it "redirects to catalog with flash" do
        allow_any_instance_of(ChatRoomService).to receive(:find_or_create_chat_room).and_return({chat_room: nil, error: 'Some error'})
        post :create, params: { participant_id: other_user.id, product_id: product.id }
        expect(response).to redirect_to(catalog_path(product))
        expect(flash[:alert]).to eq('Failed to create a chat room')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:chat_room) { create(:chat_room, creator: user, participant: other_user) }

    context 'when user is authorized and deletes chat' do
      before { sign_in user }

      it 'deletes chat, redirects to chat_rooms path with flash' do
        delete :destroy, params: { id: chat_room.id }
        expect(response).to redirect_to(chat_rooms_path)
        expect(flash[:notice]).to eq('Chat room deleted successfully.')
      end
    end

    context 'when user is not authorized' do
      let!(:chat_room) { create(:chat_room, creator: user, participant: other_user) }
      
      it 'redirects to login page with flash' do
        delete :destroy, params: { id: chat_room.id }
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end
