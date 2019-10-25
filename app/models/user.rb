# frozen_string_literal: true

class User < ApplicationRecord
  MINIMUM_PASSWORD_LENGTH = 6

  has_many :created_issues, class_name: 'Issue',
                            foreign_key: 'author_id',
                            inverse_of: :author

  has_many :managed_issues, class_name: 'Issue',
                            foreign_key: 'manager_id',
                            inverse_of: :manager

  has_secure_password
  has_enumeration_for :role, with: Users::RoleEnum

  validates :email, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: MINIMUM_PASSWORD_LENGTH }
end
