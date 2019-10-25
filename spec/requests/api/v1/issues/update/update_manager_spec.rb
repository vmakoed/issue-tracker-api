# frozen_string_literal: true

require 'rails_helper'
require 'requests/api/v1/issues/update/shared/contexts'

RSpec.describe 'Issues', type: :request do
  let(:authorized_manager) { create(:manager) }

  shared_context 'when attributes contain manager id' do
    let(:manager) { create(:manager) }
    let(:attributes) do
      {
        title: 'Updated issue',
        description: 'Updated description',
        manager_id: manager.id
      }
    end
  end

  describe 'PATCH/PUT /issues/:id
            as issue author
            with valid attributes
            and manager attribute',
           response_format: :json,
           response_status: :unauthorized do
    include_context 'when an issue exists'
    include_context 'when issue author is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes contain manager id'

    it 'does not update issue' do
      issue.reload

      expect(issue.attributes.values_at('title', 'description'))
        .not_to eq attributes.values_at(:title, :description)
    end

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end

  shared_context 'when attributes contain manager id' do
    let(:manager) { create(:manager) }
    let(:attributes) do
      {
        manager_id: manager.id
      }
    end
  end

  shared_context 'when attributes contain authorized manager id' do
    include_context 'when attributes contain manager id' do
      let(:manager) { authorized_manager }
    end
  end

  describe 'PATCH/PUT /issues/:id
            as a manager
            with manager attribute
            when manager is not assigned to issue',
           response_format: :json,
           response_status: :success do
    include_context 'when an issue exists'
    include_context 'when manager is logged in' do
      let(:user) { authorized_manager }
    end
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes contain authorized manager id'

    it 'updates issue manager' do
      issue.reload

      expect(issue.manager).to eq authorized_manager
    end
  end

  describe 'PATCH/PUT /issues/:id
            as a manager
            with manager attribute
            when another manager is assigned to issue',
           response_format: :json,
           response_status: :unauthorized do
    include_context 'when an issue exists' do
      let(:issue) { create(:issue, :with_manager) }
    end
    include_context 'when manager is logged in' do
      let(:user) { authorized_manager }
    end
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes contain authorized manager id'

    it 'does not update issue manager' do
      issue.reload

      expect(issue.manager).not_to eq authorized_manager
    end

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end

  describe 'PATCH/PUT /issues/:id
            as a manager
            with another manager attribute
            when manager is not assigned to issue',
           response_format: :json,
           response_status: :unauthorized do
    include_context 'when an issue exists'
    include_context 'when manager is logged in' do
      let(:user) { authorized_manager }
    end
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes contain manager id'

    it 'does not update issue manager' do
      issue.reload

      expect(issue.manager).not_to eq authorized_manager
    end

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end

  shared_context 'when attributes contain empty manager id' do
    let(:attributes) do
      {
        manager_id: ''
      }
    end
  end

  describe 'PATCH/PUT /issues/:id as issue manager with status attribute',
           response_format: :json,
           response_status: :success do
    include_context 'when an issue exists'
    include_context 'when issue manager is logged in'
    include_context 'when performing PATCH/PUT /issues/:id request'
    include_context 'when attributes contain empty manager id'

    it 'unassigns issue manager' do
      issue.reload

      expect(issue.manager).to be_nil
    end
  end
end
