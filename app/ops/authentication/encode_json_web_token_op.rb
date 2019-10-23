# frozen_string_literal: true

module Authentication
  class EncodeJsonWebTokenOp < ::Subroutine::Op
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
      @token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
  end
end
