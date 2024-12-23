# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  wallet_id        :bigint           not null
#  amount           :string
#  transaction_type :string
#  description      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Transaction < ApplicationRecord
  belongs_to :wallet

  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true, inclusion: { in: %w[citadele swedbank] }
end
