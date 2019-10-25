# frozen_string_literal: true

module Issues
  class FetchOp < ExistingIssueOp
    policy :show?

    outputs :issue

    protected

    def perform
      output :issue, resource
    end
  end
end
