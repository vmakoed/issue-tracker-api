# frozen_string_literal: true

class SignupOp < ApplicationOp
  string :email
  string :password
  string :role, default: Users::RoleEnum::AUTHOR

  validates :email, :password, :role, presence: true

  outputs :user

  protected

  def perform
    create_user

    output :user, @user
  end

  def create_user
    @user = User.create!(params)
  end
end
