class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, foreign_key: { to_table: :wallets }, index: true
      t.references :target_wallet, foreign_key: { to_table: :wallets }, index: true

      t.decimal :amount, precision: 12, scale: 2, null: false
      t.datetime :transaction_date_time, null: false
      t.string :transaction_type, null: false
      t.timestamps

      t.index [ :source_wallet_id, :transaction_date_time ]
      t.index [ :target_wallet_id, :transaction_date_time ]
    end
  end
end
