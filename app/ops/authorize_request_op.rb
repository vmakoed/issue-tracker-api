# frozen_string_literal: true

class AuthorizeRequestOp < ApplicationOp
  field :authorization_headers

  validates :authorization_headers, presence: true

  outputs :user

  protected

  def perform
    extract_authorization_token
    decode_user

    user = User.find(@user_id)

    unless user.present?
      errors.add(:headers, 'Invalid authorization token')
      return
    end

    output :user, user
  end

  def extract_authorization_token
    @authorization_token = authorization_headers.split(' ').last
  end

  def decode_user
    @user_id = Authentication::DecodeJsonWebTokenOp.submit!(
      token: @authorization_token
    ).user_id
  end
end
