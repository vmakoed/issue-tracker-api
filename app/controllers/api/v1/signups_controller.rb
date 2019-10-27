# frozen_string_literal: true

module Api
  module V1
    class SignupsController < Api::V1::ApiController
      def create
        operation = SignupOp.submit!(request.parameters[:user])

        render json: UserSerializer.new(operation.user), status: :created
      end
    end
  end
end
