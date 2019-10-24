# frozen_string_literal: true

require 'subroutine/auth'

module Issues
  class CreateOp < ::Subroutine::Op
    include ::Subroutine::Auth

    field :title
    field :description
    field :status, default: Issues::StatusEnum::PENDING

    require_user!

    validates :title, presence: true

    policy :create?

    outputs :issue

    protected

    def perform
      create_issue

      output :issue, @issue
    end

    def create_issue
      @issue = Issue.new(
        title: title,
        description: description,
        status: status,
        author: current_user
      )
    end

    def policy
      IssuePolicy.new(current_user, nil)
    end
  end
end
