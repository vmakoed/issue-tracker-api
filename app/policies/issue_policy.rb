# frozen_string_literal: true

class IssuePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if manager?

      user.created_issues if author?
    end
  end

  def show?
    issue_author?
  end

  def create?
    author?
  end

  def update?
    issue_author?
  end

  def update_status?
    issue_manager?
  end

  def destroy?
    issue_author?
  end

  private

  def issue_author?
    record.author == user
  end

  def issue_manager?
    record.manager == user
  end
end
