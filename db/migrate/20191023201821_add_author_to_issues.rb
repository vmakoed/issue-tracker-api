# frozen_string_literal: true

class AddAuthorToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :author_id, :integer, null: false, foreign_key: true
  end
end
