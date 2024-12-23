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
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy
  has_many :created_chat_rooms, class_name: 'ChatRoom', foreign_key: 'creator_id', dependent: :destroy
  has_many :participating_chat_rooms, class_name: 'ChatRoom', foreign_key: 'participant_id', dependent: :destroy
  has_many :messages
  has_many :favorite_products
  has_many :favorited_products, through: :favorite_products, source: :product
  has_one :wallet, dependent: :destroy

  validates_uniqueness_of :username

  validates :first_name, presence: true
  validates :last_name, presence: true

  after_create :create_user_wallet

  def chat_rooms
    ChatRoom.where('(creator_id = :user_id) OR (participant_id = :user_id AND draft = false)', user_id: id)
  end

  private

  def create_user_wallet
    Wallet.create(user: self, balance: 0)
  end
end
