# frozen_string_literal: true

require 'subroutine/auth'

module Issues
  class UpdateOp < ExistingIssueOp
    REQUIRED_ASSIGNEE_STATUSES = [
      Issues::StatusEnum::IN_PROGRESS,
      Issues::StatusEnum::RESOLVED
    ].freeze

    string :title
    string :description
    string :status
    integer :manager_id

    validate :required_assignee

    authorize -> { unauthorized! if authorization_policies.any?(&:call) }

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
      return unless (status || resource.status).in? REQUIRED_ASSIGNEE_STATUSES
      return if manager_id || resource.manager_id

      errors.add(
        :manager_id,
        "Assignee is required for status #{Issues::StatusEnum.t(status)}"
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
      [title, description].any?(&:present?) && !policy.update?
    end

    def update_status_policy
      status.present? && !policy.update_status?
    end

    def update_manager_policy
      empty_manager_id = -> { params.key?('manager_id') && manager_id.nil? }
      manager_id_provided = manager_id.present? || empty_manager_id.call

      manager_id_provided && !policy.update_manager?(manager_id)
    end
  end
end
