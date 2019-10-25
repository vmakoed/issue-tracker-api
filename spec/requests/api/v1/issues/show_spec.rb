# frozen_string_literal: true

require 'rails_helper'
require 'requests/api/v1/issues/shared/contexts'

RSpec.describe 'Issues', type: :request do
  shared_context 'when performing GET /issues/:id request' do
    before { get api_v1_issue_path(issue), headers: authorization_headers }
  end

  describe "GET /issues/:id as issue's author returns issue",
           response_format: :json,
           response_status: :success do
    include_context 'when issue author is logged in'
    include_context 'when an issue exists'
    include_context 'when performing GET /issues/:id request'

    let(:issue_json) { IssueSerializer.new(issue).serialized_json }

    it 'returns an issue in response' do
      expect(response.body).to eq issue_json
    end
  end

  describe 'GET /issues/:id as another author return is unauthorized`',
           response_format: :json,
           response_status: :unauthorized do
    include_context 'when another author is logged in'
    include_context 'when an issue exists'
    include_context 'when performing GET /issues/:id request'

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end
end
