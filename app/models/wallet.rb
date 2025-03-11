class Wallet < ApplicationRecord
  belongs_to :account
  belongs_to :entity

  validates :account_id, presence: true
  validates :entity_id, presence: true

  validates :balance, presence: true
end
