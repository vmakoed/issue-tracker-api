# frozen_string_literal: true

module Issues
  class DestroyOp < ExistingIssueOp
    policy :destroy?

    protected

    def perform
      destroy_issue
    end

    def destroy_issue
      resource.destroy
    end
  end
end
