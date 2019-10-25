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

  def update_manager?(manager_id)
    assigning_self = -> { record.manager.nil? && user.id == manager_id }
    unassigning_self = -> { record.manager == user && manager_id.nil? }

    manager? && (assigning_self.call || unassigning_self.call)
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
