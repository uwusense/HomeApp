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
