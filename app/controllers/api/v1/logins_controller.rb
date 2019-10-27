# frozen_string_literal: true

module Api
  module V1
    class LoginsController < Api::V1::ApiController
      def create
        operation = Authentication::Jwt::GenerateOp.submit!(
          request.parameters[:user]
        )

        render json: { token: operation.token }, status: :ok
      end
    end
  end
end
