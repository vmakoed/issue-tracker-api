# frozen_string_literal: true

require 'rails_helper'
require 'support/issues/shared_contexts'

RSpec.describe 'Issues', type: :request do
  describe 'GET /issues', response_format: :json, response_status: :success do
    include_context 'when issue author is logged in'
    include_context 'when an issue exists'
    include_context 'when an issue of another author exists'

    let(:issues_json) do
      IssueSerializer.new(user.created_issues).serialized_json
    end

    before do
      get api_v1_issues_path, headers: authorization_headers
    end

    it 'returns only issues created by user in response' do
      expect(response.body).to eq issues_json
    end
  end

  describe 'GET /issues', response_format: :json do
    include_context 'when manager is logged in'
    include_context 'when an issue exists'
    include_context 'when an issue of another author exists'

    let(:issues_json) do
      IssueSerializer.new(Issue.all).serialized_json
    end

    before do
      get api_v1_issues_path, headers: authorization_headers
    end

    it 'returns only issues created by user in response' do
      expect(response.body).to eq issues_json
    end
  end
end
