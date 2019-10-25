# frozen_string_literal: true

module Issues
  class ListOp < ApplicationOp
    include Pagy::Backend
    include ::Subroutine::Auth

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
      @issues = policy_scope Issue
    end

    def paginate_issues
      @pagination_metadata, @paginated_issues = pagy @issues
    end
  end
end
