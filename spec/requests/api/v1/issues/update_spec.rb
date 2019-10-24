# frozen_string_literal: true

require 'rails_helper'
require 'support/issues/shared_contexts'

RSpec.describe 'Issues', type: :request do
  shared_context 'when performing PATCH/PUT /issues/:id request' do
    before do
      put api_v1_issue_path(issue), params: { issue: attributes },
          headers: authorization_headers
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
end
