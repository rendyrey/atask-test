# frozen_string_literal: true

class Account < ApplicationRecord
  has_secure_password

  validates :name, :email, :password, presence: true
  validates :email, uniqueness: true

  after_create :create_wallets

  has_many :wallets, dependent: :destroy

  private

    def create_wallets
      entities = Entity.all

      entities.each do |entity|
        Wallet.create(account: self, entity: entity)
      end
    end
end
