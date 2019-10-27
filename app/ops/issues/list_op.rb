# frozen_string_literal: true

module Issues
  class ListOp < ApplicationOp
    include Pagy::Backend
    include ::Subroutine::Auth

    integer :page
    string :status

    validate :supported_status

    require_user!

    outputs :issues, :pagination_metadata

    protected

    def perform
      fetch_issues
      paginate_issues

      output :issues, @paginated_issues
      output :pagination_metadata, @pagination_metadata
    end

    def fetch_issues
      base_scope = policy_scope Issue
      return @issues = base_scope unless status.present?

      @issues = base_scope.with_status(status)
    end

    def supported_status
      return if status.blank? || status.in?(Issues::StatusEnum.list)

      errors.add(:status, 'Incorrect status')
    end

    def paginate_issues
      @pagination_metadata, @paginated_issues = pagy(@issues, page: page)
    end
  end
end
