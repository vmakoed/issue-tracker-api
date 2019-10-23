# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      attr_reader :current_user

      rescue_from ::Subroutine::Failure, with: :render_operation_failure

      private

      def render_operation_failure(operation_error)
        render json: { error: operation_error.message },
               status: :unprocessable_entity
      end

      def authenticate_user
        @current_user = AuthorizeRequestOp.submit!(
          authorization_headers: request.headers['Authorization']
        ).user

        return if @current_user

        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end
  end
end
