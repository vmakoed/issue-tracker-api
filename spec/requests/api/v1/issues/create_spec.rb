# frozen_string_literal: true

require 'rails_helper'
require 'requests/api/v1/issues/shared/contexts'

RSpec.describe 'Issues', type: :request do
  shared_context 'when performing POST /issues request' do
    before do
      post api_v1_issues_path, params: { issue: attributes },
                               headers: authorization_headers
    end
  end

  shared_context 'when create attributes are valid' do
    let(:attributes) do
      {
        title: 'New issue',
        description: 'Issue description'
      }
    end
  end

  describe 'POST /issues as author with valid attributes',
           response_format: :json,
           response_status: :created do
    include_context 'when author is logged in'
    include_context 'when performing POST /issues request'
    include_context 'when create attributes are valid'

    let(:issue_id) { JSON.parse(response.body)['data']['id'] }
    let(:created_issue) { Issue.find(issue_id) }
    let(:issue_attributes) { JSON.parse(response.body)['data']['attributes'] }
    let(:status) { Issues::StatusEnum::PENDING }
    let(:translated_status) { Issues::StatusEnum.t(status) }

    it 'stores a created issue' do
      expect(created_issue).to be_present
    end

    it 'returns a created issue in response' do
      expect(issue_attributes.values_at('title', 'description'))
        .to eq attributes.values_at(:title, :description)
    end

    it 'creates an issue with a default pending status' do
      expect(issue_attributes['status']).to eq translated_status
    end
  end

  shared_context 'when attributes contain status' do |status|
    let(:attributes) do
      {
        title: 'New issue',
        description: 'Issue description',
        status: status
      }
    end
  end

  describe 'POST /issues as author with valid attributes with status attribute',
           response_format: :json do
    include_context 'when author is logged in'
    include_context 'when performing POST /issues request'
    include_context 'when create attributes are valid'
    include_context 'when attributes contain status',
                    Issues::StatusEnum::IN_PROGRESS

    let(:default_status) { Issues::StatusEnum::PENDING }
    let(:translated_status) { Issues::StatusEnum.t(default_status) }
    let(:issue_attributes) { JSON.parse(response.body)['data']['attributes'] }

    it 'ignores status attribute and sets default status' do
      expect(issue_attributes['status']).to eq translated_status
    end
  end

  describe 'POST /issues as author with invalid attributes',
           response_format: :json,
           response_status: :unprocessable_entity do
    include_context 'when author is logged in'
    include_context 'when performing POST /issues request'
    include_context 'when attributes are invalid'
  end

  shared_context 'when performing PATCH/PUT /issues/:id request' do
    before do
      put api_v1_issue_path(issue), params: { issue: attributes },
                                    headers: authorization_headers
    end
  end

  describe 'POST /issues as manager with valid attributes',
           response_format: :json,
           response_status: :unauthorized do
    include_context 'when manager is logged in'
    include_context 'when performing POST /issues request'
    include_context 'when create attributes are valid'

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end

  shared_context 'when update attributes are valid' do
    let(:status) { Issues::StatusEnum::IN_PROGRESS }
    let(:attributes) do
      {
        title: 'Updated issue',
        description: 'Updated description',
        status: status
      }
    end
  end
end
