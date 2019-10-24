# frozen_string_literal: true

class IssuePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if manager?

      user.created_issues if author?
    end
  end

  def create?
    author?
  end

  def update?
    record.author == user
  end
end
