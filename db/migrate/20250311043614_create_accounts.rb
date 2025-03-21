# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :email, index: { unique: true }, null: false
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end
