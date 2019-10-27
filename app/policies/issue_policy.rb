# frozen_string_literal: true

class IssuePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if manager?

      user.created_issues if author?
    end
  end

  def show?
    issue_author? || manager?
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
    manager? && (assigning_self?(manager_id) || unassigning_self?(manager_id))
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

  def assigning_self?(manager_id)
    return true if record.manager_id == manager_id

    record.manager.blank? && user.id == manager_id
  end

  def unassigning_self?(manager_id)
    record.manager == user && manager_id.blank?
  end
end
