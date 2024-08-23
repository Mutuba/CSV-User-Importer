# frozen_string_literal: true

# CreateUsers is a migration that creates the users table with necessary fields.
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :password, :null => false

      t.timestamps
    end
  end
end
