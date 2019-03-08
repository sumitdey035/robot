# frozen_string_literal: true

class CreateToys < ActiveRecord::Migration[5.2]
  def change
    create_table :toys do |t|
      t.string  :name, null: false
      t.integer :x
      t.integer :y
      t.string  :facing
    end
  end
end
