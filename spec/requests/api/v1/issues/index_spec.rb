# frozen_string_literal: true

require 'rails_helper'
require 'requests/api/v1/issues/shared/contexts'

RSpec.describe 'Issues', type: :request do
  shared_context 'when an issue of another author exists' do
    let(:another_author) { create :author }
    before { create :issue, author: another_author }
  end

  shared_context 'when performing GET /issues request' do
    before { get api_v1_issues_path, headers: authorization_headers }
  end

  describe "GET /issues as author return only author's issues",
           response_format: :json,
           response_status: :success do
    include_context 'when issue author is logged in'
    include_context 'when an issue exists'
    include_context 'when an issue of another author exists'
    include_context 'when performing GET /issues request'

    let(:issues_json) do
      IssueSerializer.new(user.created_issues).serialized_json
    end

    it 'returns only issues created by user in response' do
      expect(response.body).to eq issues_json
    end
  end

  describe 'GET /issues as manager returns all issues',
           response_format: :json,
           response_status: :success do
    include_context 'when manager is logged in'
    include_context 'when an issue exists'
    include_context 'when an issue of another author exists'
    include_context 'when performing GET /issues request'

    let(:issues_json) do
      IssueSerializer.new(Issue.all).serialized_json
    end

    it 'returns all issues in response' do
      expect(response.body).to eq issues_json
    end
  end
end
