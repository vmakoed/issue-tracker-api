# frozen_string_literal: true

module Issues
  class CreateOp < ApplicationOp
    include ::Subroutine::Auth

    DEFAULT_STATUS = Issues::StatusEnum::PENDING

    string :title
    string :description

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
      @issue = Issue.create!(
        title: title,
        description: description,
        status: DEFAULT_STATUS,
        author: current_user
      )
    end

    def policy
      IssuePolicy.new(current_user, nil)
    end
  end
end
