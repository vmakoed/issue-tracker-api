# frozen_string_literal: true

require 'requests/api/v1/issues/shared/contexts'

shared_context 'when performing PATCH/PUT /issues/:id request' do
  before do
    put api_v1_issue_path(issue), params: { issue: attributes },
                                  headers: authorization_headers
  end
end
