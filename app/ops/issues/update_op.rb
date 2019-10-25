# frozen_string_literal: true

require 'subroutine/auth'

module Issues
  class UpdateOp < ExistingIssueOp
    string :title
    string :description
    string :status

    authorize lambda {
      if [title, description].any?(&:present?) && !policy.update?
        return unauthorized!
      end

      return unauthorized! if status.present? && !policy.update_status?
    }

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
        status: status
      }

      resource.update!(attributes.compact)
    end
  end
end
