# frozen_string_literal: true

module Api
  module V1
    class IssuesController < Api::V1::ApiController
      before_action :authenticate_user

      # GET /issues
      def index
        operation = Issues::ListOp.submit!(current_user)

        render json: IssueSerializer.new(operation.issues)
      end

      # GET /issues/1
      def show
        operation = Issues::FetchOp.submit!(current_user, id: params[:id])

        render json: IssueSerializer.new(operation.issue)
      end

      # POST /issues
      def create
        operation = Issues::CreateOp.submit!(
          current_user, issue_params.to_h
        )

        render json: IssueSerializer.new(operation.issue),
               status: :created,
               location: api_v1_issue_path(operation.issue)
      end

      # PATCH/PUT /issues/1
      def update
        operation = Issues::UpdateOp.submit!(
          current_user,
          id: params[:id],
          **issue_params.to_h.symbolize_keys
        )

        render json: IssueSerializer.new(operation.issue)
      end

      # DELETE /issues/1
      def destroy
        Issues::DestroyOp.submit!(current_user, id: params[:id])

        render json: {}, status: :no_content
      end

      private

      def issue_params
        params.require(:issue).permit(:title, :description, :status)
      end
    end
  end
end
