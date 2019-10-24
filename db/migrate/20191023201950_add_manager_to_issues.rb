# frozen_string_literal: true

class AddManagerToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :manager_id, :integer, foreign_key: true
  end
end
