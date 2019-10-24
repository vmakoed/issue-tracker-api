# frozen_string_literal: true

require 'rails_helper'
require 'support/logged_in_context'

RSpec.describe 'Issues', type: :request do
  shared_context 'when an issue exists' do
    let!(:issue) { create(:issue) }
  end

  shared_context 'when issue author is logged in' do
    include_context 'when logged in' do
      let(:user) { issue.author }
    end
  end

  describe 'GET /issues', response_format: :json do
    include_context 'when author is logged in'
    include_context 'when an issue exists'

    let(:issues_json) { IssueSerializer.new(Issue.all).serialized_json }

    before { get api_v1_issues_path, headers: authorization_headers }

    it 'returns all issues in response' do
      expect(response.body).to eq issues_json
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

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

  describe 'POST /issues with valid attributes without status attribute',
           response_format: :json do
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

    it 'returns a success response' do
      expect(response).to have_http_status(:created)
    end

    it 'creates an issue with a default pending status' do
      expect(issue_attributes['status']).to eq translated_status
    end
  end

  shared_context 'when issue params contain status' do |status|
    let(:attributes) do
      {
        title: 'New issue',
        description: 'Issue description',
        status: status
      }
    end
  end

  describe 'POST /issues with valid attributes with status attribute',
           response_format: :json do
    include_context 'when author is logged in'
    include_context 'when performing POST /issues request'
    include_context 'when create attributes are valid'

    let(:status) { Issues::StatusEnum::IN_PROGRESS }
    let(:translated_status) { Issues::StatusEnum.t(status) }
    let(:issue_attributes) { JSON.parse(response.body)['data']['attributes'] }

    include_context 'when issue params contain status',
                    Issues::StatusEnum::IN_PROGRESS

    it 'creates an issue with a correct status' do
      expect(issue_attributes['status']).to eq translated_status
    end
  end

  shared_context 'when attributes are invalid' do
    let(:attributes) do
      {
        title: ''
      }
    end
  end

  describe 'POST /issues with invalid attributes', response_format: :json do
    include_context 'when author is logged in'
    include_context 'when performing POST /issues request'
    include_context 'when attributes are invalid'

    it 'returns a failure response' do
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  shared_context 'when performing PATCH/PUT /issues/:id request' do
    before do
      put api_v1_issue_path(issue), params: { issue: attributes },
                                    headers: authorization_headers
    end
  end

  describe 'POST /issues
            by manager
            with valid attributes' do
    include_context 'when manager is logged in'
    include_context 'when performing POST /issues request'
    include_context 'when create attributes are valid'

    it 'returns a failure response' do
      expect(response).to have_http_status(:unauthorized)
    end

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

  describe 'PATCH/PUT /issues/:id with valid attributes',
           response_format: :json do
    include_context 'when an issue exists'
    include_context 'when issue author is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when update attributes are valid'

    let(:issue_attributes) { JSON.parse(response.body)['data']['attributes'] }
    let(:translated_status) { Issues::StatusEnum.t(status) }

    it 'returns an updated issue in response' do
      expect(issue_attributes.values_at('title', 'description'))
        .to eq attributes.values_at(:title, :description)
    end

    it 'returns an issue with an updated status' do
      expect(issue_attributes['status']).to eq translated_status
    end

    it 'updates the issue' do
      issue.reload

      expect(issue.attributes.values_at('title', 'description'))
        .to eq attributes.values_at(:title, :description)
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH/PUT /issues/:id with invalid attributes',
           response_format: :json do
    include_context 'when an issue exists'
    include_context 'when issue author is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes are invalid'

    it 'returns a failure response' do
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /issues/:id' do
    include_context 'when author is logged in'
    include_context 'when an issue exists'

    before { delete api_v1_issue_path(issue), headers: authorization_headers }

    it 'returns an empty response' do
      expect(response.body).to be_empty
    end

    it 'returns a no content response' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
