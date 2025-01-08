require 'rails_helper'

RSpec.describe WalletsController, type: :controller do
  let(:user) { create(:user) }
  let(:wallet) { user.wallet }
  let(:transactions) { create_list(:transaction, 3, wallet:) }

  before do
    sign_in user
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #add_funds' do
    context 'when adding funds is successful' do
      it 'adds funds to the wallet and redirects with a notice' do
        expect do
          post :add_funds, params: { id: wallet.id, amount: '100', transaction_type: 'citadele' }
        end.to change(wallet.transactions, :count).by(1)
        expect(response).to redirect_to(wallets_path)
        expect(flash[:notice]).to eq('Funds added successfully!')
      end
    end

    context 'when adding funds fails' do
      it 'does not add funds and redirects with an alert' do
        allow_any_instance_of(Wallet).to receive(:update_balance!).and_return(false)
        post :add_funds, params: { id: wallet.id, amount: 'invalid_amount', transaction_type: 'citadele' }
        expect(response).to redirect_to(wallets_path)
        expect(flash[:alert]).to eq('Failed to add funds')
      end
    end
  end
end
