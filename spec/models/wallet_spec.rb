require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:transactions) }
  end

  describe '#update_balance!' do
    let(:user) { create(:user) }
    let(:wallet) { user.wallet }
    let(:amount) { 50.00 }
    let(:transaction_type) { 'citadele' }

    context 'when transaction is valid' do
      it 'creates a transaction and updates the balance' do
        expect {
          wallet.update_balance!(amount, transaction_type)
        }.to change(Transaction, :count).by(1)
        .and change { wallet.reload.balance }.by(amount)
        
        last_transaction = Transaction.last
        expect(last_transaction.amount.to_f).to eq(amount)
        expect(last_transaction.transaction_type).to eq(transaction_type)
      end
    end

    context 'when transaction is invalid' do
      it 'does not update the balance and returns false' do
        allow_any_instance_of(Transaction).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(Transaction.new))
        expect(wallet.update_balance!(nil, transaction_type)).to be false
        expect(wallet.reload.balance).to eq(wallet.balance)
      end
    end
  end
end
