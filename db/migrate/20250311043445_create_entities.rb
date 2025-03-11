# frozen_string_literal: true

class CreateEntities < ActiveRecord::Migration[8.0]
  def change
    create_table :entities do |t|
      t.string :entity_name, null: false
      t.string :entity_type, index: { unique: true }, null: false
      t.timestamps
    end
  end
end
