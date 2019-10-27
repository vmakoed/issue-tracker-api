# frozen_string_literal: true

module Authentication
  module Jwt
    class GenerateOp < ::Subroutine::Op
      field :email
      field :password

      validates :email, :password, presence: true
      validate :validate_user_exists
      validate :validate_password_correct

      outputs :token

      protected

      def perform
        issue_token

        output :token, @token
      end

      def validate_user_exists
        return if user.present?

        errors.add(:user, 'does not exist')
      end

      def validate_password_correct
        return if user.blank? || authenticate_user

        errors.add(:password, 'is incorrect')
      end

      def authenticate_user
        user&.authenticate(password)
      end

      def issue_token
        @token = Authentication::Jwt::EncodeOp.submit!(user_id: @user.id).token
      end

      def user
        @user ||= User.find_by(email: email)
      end
    end
  end
end
