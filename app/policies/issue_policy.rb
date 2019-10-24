# frozen_string_literal: true

class IssuePolicy < ApplicationPolicy
  def create?
    user.role == Users::RoleEnum::AUTHOR
  end

  def update?
    record.author == user
  end
end
