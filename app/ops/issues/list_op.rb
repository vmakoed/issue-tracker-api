# frozen_string_literal: true

module Issues
  class ListOp < ApplicationOp
    include ::Subroutine::Auth

    require_user!

    outputs :issues

    protected

    def perform
      fetch_issues

      output :issues, @issues
    end

    def fetch_issues
      @issues = policy_scope Issue
    end
  end
end
