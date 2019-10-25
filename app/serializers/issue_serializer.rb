# frozen_string_literal: true

class IssueSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title, :description

  attribute :status, &:status_humanize

  belongs_to :author, record_type: :user
  belongs_to :manager, record_type: :user
end
