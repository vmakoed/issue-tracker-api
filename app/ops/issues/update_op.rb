# frozen_string_literal: true

require 'subroutine/auth'

module Issues
  class UpdateOp < ExistingIssueOp
    string :title
    string :description
    string :status
    integer :manager_id

    authorize -> { unauthorized! if authorization_policies.any?(&:call) }

    outputs :issue

    protected

    def perform
      update_issue

      output :issue, resource
    end

    def update_issue
      attributes = {
        title: title,
        description: description,
        status: status,
        manager_id: manager_id
      }

      resource.update!(attributes.compact)
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
      empty_manager_id = ->() { params.key?('manager_id') && manager_id.nil? }
      manager_id_provided = manager_id.present? || empty_manager_id.call

      manager_id_provided  && !policy.update_manager?(manager_id)
    end
  end
end
