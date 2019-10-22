# frozen_string_literal: true

class IssueSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title, :description

  attribute :status, &:status_humanize
end
