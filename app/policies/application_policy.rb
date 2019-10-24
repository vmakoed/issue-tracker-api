# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def manager?
    user.role == Users::RoleEnum::MANAGER
  end

  def author?
    user.role == Users::RoleEnum::AUTHOR
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    def manager?
      user.role == Users::RoleEnum::MANAGER
    end

    def author?
      user.role == Users::RoleEnum::AUTHOR
    end
  end
end
