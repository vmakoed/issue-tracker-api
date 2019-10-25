# frozen_string_literal: true

require 'rails_helper'
require 'requests/api/v1/issues/update/shared/contexts'

RSpec.describe 'Issues', type: :request do
  shared_context 'when update attributes are valid' do
    let(:attributes) do
      {
        title: 'Updated issue',
        description: 'Updated description'
      }
    end
  end

  describe 'PATCH/PUT /issues/:id as issue author with valid attributes',
           response_format: :json,
           response_status: :success do
    include_context 'when an issue exists'
    include_context 'when issue author is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when update attributes are valid'

    let(:issue_attributes) { JSON.parse(response.body)['data']['attributes'] }

    it 'returns an updated issue in response' do
      expect(issue_attributes.values_at('title', 'description'))
        .to eq attributes.values_at(:title, :description)
    end

    it 'updates the issue' do
      issue.reload

      expect(issue.attributes.values_at('title', 'description'))
        .to eq attributes.values_at(:title, :description)
    end
  end

  describe 'PATCH/PUT /issues/:id as another author with valid attributes',
           response_format: :json,
           response_status: :unauthorized do
    include_context 'when an issue exists'
    include_context 'when another author is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when update attributes are valid'

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end

  describe 'PATCH/PUT /issues/:id as issue author with invalid attributes',
           response_format: :json,
           response_status: :unprocessable_entity do
    include_context 'when an issue exists'
    include_context 'when issue author is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes are invalid'

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end

  describe 'PATCH/PUT /issues/:id as issue manager with non-status attributes',
           response_format: :json,
           response_status: :unauthorized do
    include_context 'when an issue exists'
    include_context 'when issue manager is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when update attributes are valid'

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end
end
