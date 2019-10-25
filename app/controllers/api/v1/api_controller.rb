# frozen_string_literal: true

require 'subroutine/auth'

module Api
  module V1
    class ApiController < ApplicationController
      attr_reader :current_user

      rescue_from ::Subroutine::Failure, with: :render_operation_failure
      rescue_from ::Subroutine::Auth::NotAuthorizedError,
                  with: :render_authorization_failure

      private

      def authenticate_user
        operation = AuthorizeRequestOp.submit!(
          authorization_headers: request.headers['Authorization']
        )

        @current_user = operation.user
        return if @current_user

        render json: { error: 'Not Authorized' }, status: :unauthorized
      end

      def render_operation_failure(operation_error)
        render json: { error: operation_error.message },
               status: :unprocessable_entity
      end

      def render_authorization_failure(operation_error)
        render json: { error: operation_error.message },
               status: :unauthorized
      end
    end
  end
end
