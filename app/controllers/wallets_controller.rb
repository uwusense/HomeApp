class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallet

  # wallet creates in association for user upon creation of user

  def index
    @transactions = @wallet.transactions.order(created_at: :desc)
  end

  def add_funds
    amount = params[:amount].to_d
    type = params[:transaction_type]
    if amount > 0 && @wallet.update_balance!(amount, type)
      redirect_to wallets_path, notice: t(:ok_funds, scope: 'flash')
    else
      redirect_to wallets_path, alert: t(:failed_funds, scope: 'flash')
    end
  end

  private

  def set_wallet
    @wallet = current_user.wallet
  end
end
