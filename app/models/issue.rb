# frozen_string_literal: true

class Issue < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :created_issues
  belongs_to :manager, class_name: 'User',
                       inverse_of: :managed_issues,
                       optional: true

  validates :title, presence: true

  has_enumeration_for :status, with: Issues::StatusEnum, required: true

  scope :with_status, ->(status) { where(status: status) }
end
