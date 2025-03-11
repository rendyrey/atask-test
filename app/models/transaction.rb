# frozen_string_literal: true

class Transaction < ApplicationRecord
  self.table_name = "transactions"
  belongs_to :source_wallet, class_name: "Wallet", foreign_key: "source_wallet_id", optional: true
  belongs_to :target_wallet, class_name: "Wallet", foreign_key: "target_wallet_id", optional: true

  after_create :update_wallets

  def self.valid_top_up?(params)
    return false, "Amount should be greater than 0" if params[:amount].to_f <= 0
    return false, "Wallet not found" unless Wallet.find(params[:wallet_id]).present?

    return true, nil
  end

  def self.valid_withdraw?(current_user, params)
    return false, "Amount should be greater than 0" if params[:amount].to_f <= 0

    user_wallets = current_user.wallets
    return false, "Wallet not found" unless Wallet.find(params[:wallet_id]).present?

    wallet = user_wallets.find_by(id: params[:wallet_id])
    return false, "Insufficient balance" if wallet.balance < params[:amount].to_f

    return true, nil
  end

  def self.valid_transfer?(current_user, params)
    return false, "Amount should be greater than 0" if params[:amount].to_f <= 0
    return false, "Target wallet should be different from source wallet" if params[:source_wallet_id] == params[:target_wallet_id]

    source_wallet = current_user.wallets.find_by(id: params[:source_wallet_id])
    return false, "Source wallet is invalid" unless source_wallet.present?
    return false, "Insufficient balance" if source_wallet.balance < params[:amount].to_f

    return true, nil
  end


  private

    def update_wallets
      if self.transaction_type == "debit"
        source_wallet.update_balance
      elsif self.transaction_type == "credit"
        target_wallet.update_balance
      elsif self.transaction_type == "transfer"
        source_wallet.update_balance
        target_wallet.update_balance
      end
    end
end
