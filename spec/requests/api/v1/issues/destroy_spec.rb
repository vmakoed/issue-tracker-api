# frozen_string_literal: true

require 'rails_helper'
require 'support/issues/shared_contexts'

RSpec.describe 'Issues', type: :request, response_status: :no_content do
  describe 'DELETE /issues/:id as issue author' do
    include_context 'when issue author is logged in'
    include_context 'when an issue exists'

    before { delete api_v1_issue_path(issue), headers: authorization_headers }

    it 'returns an empty response' do
      expect(response.body).to be_empty
    end
  end

  describe 'DELETE /issues/:id as another author',
           response_status: :unauthorized do
    include_context 'when author is logged in'
    include_context 'when an issue exists'

    before { delete api_v1_issue_path(issue), headers: authorization_headers }

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end

  describe 'DELETE /issues/:id as manager',
           response_status: :unauthorized do
    include_context 'when issue manager is logged in'
    include_context 'when an issue exists'

    before { delete api_v1_issue_path(issue), headers: authorization_headers }

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end
end
