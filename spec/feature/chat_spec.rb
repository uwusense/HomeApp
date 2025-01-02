require 'rails_helper'

RSpec.describe "Catalog", type: :feature, js: true do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user, username: 'Test_username_2') }
  let!(:product_1) { create(:product, user: user_1) }
  let!(:product_2) { create(:product, user: user_2) }

  describe 'when creates a chatroom' do
    before { login(user_1) }

    it 'has correct content' do
      visit catalogs_path(tab: 'doors_windows')
      find('.catalog_item__seller', text: product_2.user.username).click
      click_button 'Contact with seller'

      expect(user_1.created_chat_rooms.count).to eq(1)
      expect(user_1.chat_rooms.count).to eq(1)

      expect(user_2.participating_chat_rooms.count).to eq(1)
      # user_2.chat_rooms wont return chatroom, because its draft
      expect(user_2.chat_rooms.count).to eq(0)

      expect(user_1.chat_rooms.first.draft).to eq(true)

      within('.chat_list_item') do
        expect(page).to have_css('.chat_list_item__user_name', text: user_2.username)
        expect(page).to have_css('.chat_list_item__draft', text: I18n.t(:draft, scope: 'chats'))
      end

      find('.chat_list_item').click

      within('.chat_block') do
        within('.chat_block_header') do
          expect(page).to have_css('.chat_block_header__user_name', text: user_2.username)
          expect(page).to have_button('Delete')
          expect(page).to have_text(I18n.t(:draft_warning, scope: 'chats'))
        end
      end
    end
  end

  describe 'when user has chat' do
    before do
      login(user_1)
      visit catalogs_path(tab: 'doors_windows')
      find('.catalog_item__seller', text: product_2.user.username).click
      click_button 'Contact with seller'
    end

    it 'can chat to another user' do
      find('.chat_list_item').click

      within('.chat_block_actions') do
        fill_in 'message[body]', with: 'hello friend'
        expect { 
          find('input[type="submit"]', match: :first).click
        }.to change { ChatRoom.first.messages.count }.by(1)
      end

      within('.chat_block_actions') do
        fill_in 'message[body]', with: ''
        expect {
          find('input[type="submit"]', match: :first).click
        }.to change { ChatRoom.first.messages.count }.by(0)
      end

      within('.chat_block_communication') do
        expect(page).to have_css('.message_content')
        expect(page).to have_css('.message__title', text: user_1.username)
        expect(page).to have_css('.message__date', text: user_1.chat_rooms.first.messages.first.created_at.strftime("%d. %b. %H:%M"))
        expect(page).to have_css('.message__body', text: 'hello friend')
      end

      expect(user_2.chat_rooms.count).to eq(1)
      expect(user_1.chat_rooms.first.draft).to eq(false)

      within('.chat_list_item') do
        expect(page).to have_no_css('.chat_list_item__draft', text: I18n.t(:draft, scope: 'chats'))
      end

      within('.chat_block') do
        within('.chat_block_header') do
          expect(page).to have_no_text(I18n.t(:draft_warning, scope: 'chats'))
        end
      end
    end

    it 'can delete chat' do
      find('.chat_list_item').click

      expect(user_1.created_chat_rooms.count).to eq(1)
      expect(user_1.chat_rooms.count).to eq(1)
      expect(user_2.participating_chat_rooms.count).to eq(1)

      within('.chat_block') do
        within('.chat_block_header') do
          expect(page).to have_button('Delete')
          
          accept_confirm do
            click_button 'Delete'
          end
        end
      end

      expect(page).to have_css('.flash', text: 'Chat room deleted successfully.')

      within('.chat_list') do
        expect(page).to have_no_css('.chat_list_item')
      end

      within('.chat_block') do
        expect(page).to have_css('.chat_room__unselected', text: 'No chatroom selected')
      end

      expect(user_1.created_chat_rooms.count).to eq(0)
      expect(user_1.chat_rooms.count).to eq(0)
      expect(user_2.participating_chat_rooms.count).to eq(0)
    end
  end

  describe 'when user is not logged in' do
    it 'chatting is not an option' do
      visit catalogs_path(tab: 'doors_windows')
      find('.catalog_item__seller', text: product_2.user.username).click

      expect(page).to have_no_text('Contact with seller')
      click_on 'Login for more actions'
      expect(page).to have_current_path("/en/users/sign_in")
    end
  end
end
