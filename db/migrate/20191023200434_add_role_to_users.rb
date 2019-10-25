# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[6.0]
  DEFAULT_ROLE = 'author'

  def change
    add_column :users, :role, :string, null: false, default: DEFAULT_ROLE
  end
end
