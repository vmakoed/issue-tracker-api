# frozen_string_literal: true

class AddStatusToIssue < ActiveRecord::Migration[6.0]
  DEFAULT_STATUS = 'pending'

  def change
    add_column :issues, :status, :string, null: false, default: DEFAULT_STATUS
  end
end
