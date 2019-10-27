# frozen_string_literal: true

require 'subroutine/auth'

module Issues
  class UpdateOp < ExistingIssueOp
    REQUIRED_ASSIGNEE_STATUSES = Issues::StatusEnum.values_for(%w[
                                                                 IN_PROGRESS
                                                                 RESOLVED
                                                               ]).freeze

    string :title
    string :description
    string :status
    integer :manager_id

    validate :required_assignee
    validate :manager_with_id_existence

    authorize -> { unauthorized! unless authorization_policies.all?(&:call) }

    outputs :issue

    protected

    def perform
      update_issue

      output :issue, resource
    end

    def update_issue
      resource.update!(params)
    end

    def required_assignee
      target_status = status || resource.status

      return unless target_status.in? REQUIRED_ASSIGNEE_STATUSES
      return if !manager_id_provided? && resource.manager
      return if manager_id

      errors.add(
        :manager_id,
        "is required for status #{Issues::StatusEnum.t(target_status)}"
      )
    end

    def manager_with_id_existence
      return if manager_id.blank?
      return if User.where(role: Users::RoleEnum::MANAGER).exists?(manager_id)

      errors.add(
        :manager_id,
        'does not exist'
      )
    end

    def authorization_policies
      [
        method(:basic_attributes_policy),
        method(:update_status_policy),
        method(:update_manager_policy)
      ]
    end

    def basic_attributes_policy
      [title, description].all?(&:blank?) || policy.update?
    end

    def update_status_policy
      return true if manager_id_provided?

      status.blank? || policy.update_status?
    end

    def update_manager_policy
      !manager_id_provided? || policy.update_manager?(manager_id)
    end

    def manager_id_provided?
      params.key?('manager_id')
    end
  end
end
