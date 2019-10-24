# frozen_string_literal: true

class User < ApplicationRecord
  has_many :created_issues, class_name: 'Issue',
                            foreign_key: 'author_id',
                            inverse_of: :author

  has_many :managed_issues, class_name: 'Issue',
                            foreign_key: 'manager_id',
                            inverse_of: :manager

  has_secure_password
  has_enumeration_for :role, with: Users::RoleEnum

  validates :email, uniqueness: true
end
