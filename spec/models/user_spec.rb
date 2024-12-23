# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string           not null
#  last_name              :string           not null
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without a unique username' do
      create(:user, username: 'johndoe')
      user = build(:user, username: 'johndoe')
      expect(user).not_to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:products).dependent(:destroy) }
    it { should have_many(:created_chat_rooms).class_name('ChatRoom').with_foreign_key('creator_id').dependent(:destroy) }
    it { should have_many(:participating_chat_rooms).class_name('ChatRoom').with_foreign_key('participant_id').dependent(:destroy) }
    it { should have_many(:messages) }
    it { should have_many(:favorite_products) }
    it { should have_many(:favorited_products).through(:favorite_products).source(:product) }
    it { should have_one(:wallet).dependent(:destroy) }
  end

  describe '#latest_message' do
    let(:chat_room) { create(:chat_room) }
    let(:message) { create(:message, chat_room: chat_room) }

    it 'returns the latest message' do
      chat_room.messages << message
      expect(chat_room.latest_message).to eq(message)
    end
  end

  describe 'callbacks' do
    let(:chat_room) { create(:chat_room) }

    it 'triggers broadcast_latest_message on update' do
      expect(chat_room).to receive(:broadcast_latest_message)
      chat_room.run_callbacks(:update_commit)
    end
  end
end
