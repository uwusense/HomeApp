class Transaction < ApplicationRecord
  belongs_to :wallet

  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true, inclusion: { in: %w[citadele swedbank] }
end
