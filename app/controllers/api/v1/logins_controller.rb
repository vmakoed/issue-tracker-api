# frozen_string_literal: true

module Api
  module V1
    class LoginsController < Api::V1::ApiController
      # POST /login
      def create
        operation = Authentication::IssueJsonWebTokenOp.submit!(
          user_params.to_h
        )

        render json: { token: operation.token }, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
