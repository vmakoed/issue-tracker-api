# frozen_string_literal: true

class Issue < ApplicationRecord
  validates :title, presence: true

  has_enumeration_for :status, with: Issues::StatusEnum
end
