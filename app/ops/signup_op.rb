# frozen_string_literal: true

class SignupOp < ApplicationOp
  string :email
  string :password

  validates :email, presence: true
  validates :password, presence: true

  outputs :user

  protected

  def perform
    create_user

    output :user, @user
  end

  def create_user
    @user = User.create!(email: email, password: password)
  end
end
