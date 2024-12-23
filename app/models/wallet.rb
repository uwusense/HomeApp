# == Schema Information
#
# Table name: wallets
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  balance    :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Wallet < ApplicationRecord
  belongs_to :user

  has_many :transactions

  def update_balance!(amount, type)
    ActiveRecord::Base.transaction do
      transactions.create!(amount: amount, transaction_type: type)
      update!(balance: balance + amount)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end
end
