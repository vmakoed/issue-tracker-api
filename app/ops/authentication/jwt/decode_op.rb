# frozen_string_literal: true

module Authentication
  module Jwt
    class DecodeOp < ::Subroutine::Op
      field :token

      validates :token, presence: true

      outputs :user_id

      protected

      def perform
        decode_token

        output :user_id, @user_hash['user_id']
      end

      def decode_token
        body = ::JWT.decode(
          token, Rails.application.secrets.secret_key_base
        )[0]
        @user_hash = HashWithIndifferentAccess.new(body)
      end
    end
  end
end
