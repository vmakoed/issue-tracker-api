# frozen_string_literal: true

module Issues
  class FindOp < ExistingIssueOp
    policy :show?

    outputs :issue

    protected

    def perform
      output :issue, resource
    end
  end
end
