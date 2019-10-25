# frozen_string_literal: true

module Issues
  class ExistingIssueOp < ApplicationOp
    include ::Subroutine::Auth

    integer :id

    validates :id, presence: true

    require_user!

    protected

    def perform
      raise NotImplementedError
    end

    def policy
      IssuePolicy.new(current_user, resource)
    end

    def resource
      @resource ||= Issue.find(id)
    end
  end
end
