# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true
end
