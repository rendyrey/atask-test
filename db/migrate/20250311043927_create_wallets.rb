# frozen_string_literal: true

class CreateWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :wallets do |t|
      t.references :account, null: false, foreign_key: { to_table: :accounts, on_delete: :cascade }
      t.references :entity, null: false, foreign_key: { to_table: :entities, on_delete: :cascade }

      t.decimal :balance, precision: 12, scale: 2, null: false, default: 0
      t.index [ :account_id, :entity_id ], unique: true
      t.timestamps
    end
  end
end
