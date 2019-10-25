# frozen_string_literal: true

module Api
  module V1
    class IssuesController < Api::V1::ApiController
      include Pagy::Backend

      before_action :authenticate_user

      def index
        operation = Issues::ListOp.submit!(
          current_user,
          request.parameters
        )
        pagy_headers_merge(operation.pagination_metadata)

        render json: IssueSerializer.new(operation.issues)
      end

      def show
        operation = Issues::FindOp.submit!(current_user, id: params[:id])

        render json: IssueSerializer.new(operation.issue)
      end

      def create
        operation = Issues::CreateOp.submit!(
          current_user, request.parameters[:issue]
        )

        render json: IssueSerializer.new(operation.issue),
               status: :created,
               location: api_v1_issue_path(operation.issue)
      end

      def update
        operation = Issues::UpdateOp.submit!(
          current_user,
          id: request.parameters[:id],
          **request.parameters[:issue].symbolize_keys
        )

        render json: IssueSerializer.new(operation.issue)
      end

      def destroy
        Issues::DestroyOp.submit!(current_user, id: request.parameters[:id])

        render json: {}, status: :no_content
      end
    end
  end
end
