# frozen_string_literal: true

class Issue < ApplicationRecord
  validates :title, presence: true
end
