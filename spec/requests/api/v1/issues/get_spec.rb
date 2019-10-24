# frozen_string_literal: true

require 'rails_helper'
require 'support/issues/shared_contexts'

RSpec.describe 'Issues', type: :request do
  describe 'GET /issues/:id', response_format: :json do
    include_context 'when author is logged in'
    include_context 'when an issue exists'

    let(:issue_json) { IssueSerializer.new(issue).serialized_json }

    before { get api_v1_issue_path(issue), headers: authorization_headers }

    it 'returns an issue in response' do
      expect(response.body).to eq issue_json
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end
end
