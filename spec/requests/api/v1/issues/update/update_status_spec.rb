# frozen_string_literal: true

require 'rails_helper'
require 'requests/api/v1/issues/update/shared/contexts'

RSpec.describe 'Issues', type: :request do
  shared_context 'when attributes contain status' do |status|
    let(:attributes) do
      {
        title: 'Updated issue',
        description: 'Updated description',
        status: status
      }
    end
  end

  describe 'PATCH/PUT /issues/:id
            as issue author
            with valid attributes
            and status attribute',
           response_format: :json,
           response_status: :unauthorized do
    include_context 'when an issue exists'
    include_context 'when issue author is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes contain status',
                    Issues::StatusEnum::IN_PROGRESS

    it 'does not update issue' do
      issue.reload

      expect(issue.attributes.values_at('title', 'description'))
        .not_to eq attributes.values_at(:title, :description)
    end
  end

  shared_context 'when attributes only contain status' do |status|
    let(:attributes) { { status: status } }
  end

  describe 'PATCH/PUT /issues/:id as issue manager with status attribute',
           response_format: :json,
           response_status: :success do
    include_context 'when an issue exists'
    include_context 'when issue manager is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes only contain status',
                    Issues::StatusEnum::IN_PROGRESS

    let(:status) { Issues::StatusEnum::IN_PROGRESS }
    let(:translated_status) { Issues::StatusEnum.t(status) }
    let(:issue_attributes) { JSON.parse(response.body)['data']['attributes'] }

    it 'updates issue status' do
      expect(issue_attributes['status']).to eq translated_status
    end
  end

  describe 'PATCH/PUT /issues/:id as another manager with status attribute',
           response_format: :json,
           response_status: :unauthorized do
    include_context 'when an issue exists'
    include_context 'when manager is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes only contain status',
                    Issues::StatusEnum::IN_PROGRESS

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end
end
