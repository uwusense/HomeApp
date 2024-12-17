class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallet

  def index
    @transactions = @wallet.transactions
  end

  def add_funds
    amount = params[:amount].to_d
    type = params[:transaction_type]
    if @wallet.update_balance!(amount, type)
      redirect_to wallets_path, notice: 'Funds added successfully!'
    else
      redirect_to wallets_path, alert: 'Failed to add funds'
    end
  end

  private

  def set_wallet
    @wallet = current_user.wallet
  end
end
