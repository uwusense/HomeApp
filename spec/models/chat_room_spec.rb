# == Schema Information
#
# Table name: chat_rooms
#
#  id              :bigint           not null, primary key
#  topic           :string
#  draft           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :bigint           not null
#  participant_id  :bigint           not null
#  last_message_at :datetime
#
require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  describe 'associations' do
    it { should belong_to(:creator).class_name('User').with_foreign_key('creator_id') }
    it { should belong_to(:participant).class_name('User').with_foreign_key('participant_id') }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe 'instance methods' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:chat_room) { create(:chat_room, creator: user, participant: other_user) }
    let!(:message) { create(:message, chat_room: chat_room, user: user) }

    describe '#target_person' do
      it 'returns the participant when curr user is creator' do
        expect(chat_room.target_person(user)).to eq(other_user)
      end

      it 'returns the creator when curr user is participant' do
        expect(chat_room.target_person(other_user)).to eq(user)
      end
    end

    describe '#latest_message' do
      it 'returns the latest message' do
        expect(chat_room.latest_message).to eq(message)
      end
    end
  end
end
