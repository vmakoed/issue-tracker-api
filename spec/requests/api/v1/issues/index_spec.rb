# frozen_string_literal: true

require 'rails_helper'
require 'requests/api/v1/issues/shared/contexts'

RSpec.describe 'Issues', type: :request do
  shared_context 'when an issue of another author exists' do
    let(:another_author) { create :author }
    let(:status) { Issues::StatusEnum::PENDING }

    before { create :issue, status: status, author: another_author }
  end

  shared_context 'when performing GET /issues request' do
    let(:params) { {} }

    before do
      get api_v1_issues_path, params: params, headers: authorization_headers
    end
  end

  describe 'GET /issues as author',
           response_format: :json,
           response_status: :success do
    include_context 'when issue author is logged in'
    include_context 'when an issue exists'
    include_context 'when an issue of another author exists'
    include_context 'when performing GET /issues request'

    let(:issues_json) do
      IssueSerializer.new(user.created_issues).serialized_json
    end

    let(:header) { response.header }
    let(:pagination_metadata_keys) do
      %w[Link Current-Page Page-Items Total-Pages Total-Count]
    end
    let(:items_per_page) { 25 }

    it 'returns only issues created by user in response' do
      expect(response.body).to eq issues_json
    end

    it 'returns pagination metadata' do
      expect(pagination_metadata_keys - headers.keys).to be_empty
    end

    it 'returns correct number of items per page' do
      expect(headers['Page-Items']).to eq items_per_page
    end
  end

  shared_context 'when an issue by author with status exists' do |status|
    let(:author) { create(:author) }

    before { create(:issue, author: author, status: status) }
  end

  shared_context 'when performing GET /issues with status param' do |status|
    include_context 'when performing GET /issues request' do
      let(:params) { { status: status } }
    end
  end

  describe 'GET /issues as author and filter them by pending status',
           response_format: :json,
           response_status: :success do
    include_context 'when logged in' do
      let(:user) { authorized_author }
    end
    include_context 'when an issue by author with status exists',
                    Issues::StatusEnum::PENDING do
                      let(:author) { authorized_author }
                    end
    include_context 'when an issue by author with status exists',
                    Issues::StatusEnum::IN_PROGRESS do
                      let(:author) { authorized_author }
                    end
    include_context 'when performing GET /issues with status param',
                    Issues::StatusEnum::PENDING

    let(:authorized_author) { create(:author) }
    let(:status) { Issues::StatusEnum::PENDING }
    let(:issues_json) do
      IssueSerializer.new(
        authorized_author.created_issues.with_status(status)
      ).serialized_json
    end

    it 'only returns issues with pending status' do
      expect(response.body).to eq issues_json
    end
  end

  describe 'GET /issues as manager',
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

  describe 'GET /issues as manager and filter them by pending status',
           response_format: :json,
           response_status: :success do
    include_context 'when manager is logged in'
    include_context 'when an issue exists' do
      let(:status) { Issues::StatusEnum::PENDING }
    end
    include_context 'when an issue of another author exists' do
      let(:status) { Issues::StatusEnum::IN_PROGRESS }
    end
    include_context 'when performing GET /issues with status param',
                    Issues::StatusEnum::PENDING

    let(:issues_json) do
      IssueSerializer.new(
        Issue.with_status(Issues::StatusEnum::PENDING)
      ).serialized_json
    end

    it 'returns issues from all authors with pending status in response' do
      expect(response.body).to eq issues_json
    end
  end
end
