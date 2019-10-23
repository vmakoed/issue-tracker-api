# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      rescue_from ::Subroutine::Failure, with: :render_operation_failure

      def render_operation_failure(operation_error)
        render json: { error: operation_error.message },
               status: :unprocessable_entity
      end
    end
  end
end
