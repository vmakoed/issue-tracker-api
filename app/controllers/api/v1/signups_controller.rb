# frozen_string_literal: true

module Api
  module V1
    class SignupsController < Api::V1::ApiController
      # POST /signup
      def create
        operation = SignupOp.submit!(user_params.to_h)

        render json: UserSerializer.new(operation.user), status: :created
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
