# frozen_string_literal: true

module Api
  module V1
    class IssuesController < Api::V1::ApiController
      before_action :authenticate_user
      before_action :set_issue, only: %i[show update destroy]

      # GET /issues
      def index
        @issues = Issue.all

        render json: IssueSerializer.new(@issues)
      end

      # GET /issues/1
      def show
        render json: issue_json
      end

      # POST /issues
      def create
        @issue = Issue.new(issue_params)

        if @issue.save
          render json: issue_json,
                 status: :created,
                 location: api_v1_issue_path(@issue)
        else
          render json: @issue.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /issues/1
      def update
        if @issue.update(issue_params)
          render json: issue_json
        else
          render json: @issue.errors, status: :unprocessable_entity
        end
      end

      # DELETE /issues/1
      def destroy
        @issue.destroy

        render json: {}, status: :no_content
      end

      private

      def issue_json
        IssueSerializer.new(@issue)
      end

      def set_issue
        @issue = Issue.find(params[:id])
      end

      def issue_params
        params.require(:issue).permit(:title, :description, :status)
      end
    end
  end
end
