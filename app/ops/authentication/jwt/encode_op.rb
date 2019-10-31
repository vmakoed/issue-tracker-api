# frozen_string_literal: true

module Authentication
  module Jwt
    class EncodeOp < ::Subroutine::Op
      field :user_id
      field :expiration, default: 24.hours.from_now

      validates :user_id, presence: true

      outputs :token

      protected

      def perform
        encode_token

        output :token, @token
      end

      def encode_token
        payload = { user_id: user_id, exp: expiration.to_i }
        @token = ::JWT.encode(
          payload, ENV['SECRET_KEY_BASE']
        )
      end
    end
  end
end
