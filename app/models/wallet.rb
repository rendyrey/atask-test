# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :account
  belongs_to :entity

  validates :account_id, presence: true
  validates :entity_id, presence: true

  validates :balance, presence: true

  def update_balance
    credits = Transaction.where(target_wallet_id: id, transaction_type: [ :credit, :transfer ]).sum(:amount)
    debits = Transaction.where(source_wallet_id: id, transaction_type: [ :debit, :transfer ]).sum(:amount)
    update(balance: credits - debits)
  end

  def balance
    read_attribute(:balance).to_f
  end
end
