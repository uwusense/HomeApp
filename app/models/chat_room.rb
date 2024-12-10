class ChatRoom < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :participant, class_name: 'User', foreign_key: 'participant_id'

  has_many :messages, dependent: :destroy

  broadcasts

  def target_person(current_user)
    current_user == creator ? participant : creator
  end
end
