# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Issues', type: :request do
  let(:valid_attributes) do
    {
      title: 'New issue',
      description: 'Issue description'
    }
  end

  let(:invalid_attributes) do
    {
      title: ''
    }
  end

  describe 'GET /issues', response_format: :json do
    let!(:issue) { Issue.create(valid_attributes) }
    let(:issues_json) { IssueSerializer.new(Issue.all).serialized_json }

    before { get api_v1_issues_path }

    it 'returns all issues in response' do
      expect(response.body).to eq issues_json
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /issues/:id', response_format: :json do
    let!(:issue) { Issue.create(valid_attributes) }
    let(:issue_json) { IssueSerializer.new(issue).serialized_json }

    before { get api_v1_issue_path(issue) }

    it 'returns an issue in response' do
      expect(response.body).to eq issue_json
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /issues', response_format: :json do
    before { post api_v1_issues_path, params: { issue: attributes } }

    context 'with valid attributes' do
      let(:attributes) { valid_attributes }
      let(:issue_attributes) { JSON.parse(response.body)['data']['attributes'] }

      it 'returns a created issue in response' do
        expect(issue_attributes['title']).to eq valid_attributes[:title]
        expect(issue_attributes['description'])
          .to eq valid_attributes[:description]
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
      end

      it 'returns response in json format' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      context 'when issue params does not contain status' do
        let(:humanized_status) do
          Issues::StatusEnum.t(Issues::StatusEnum::PENDING)
        end

        it 'creates an issue with a default pending status' do
          expect(issue_attributes['status']).to eq humanized_status
        end
      end

      context 'when issue params contain status' do
        let(:status) { Issues::StatusEnum::IN_PROGRESS }
        let(:translated_status) { Issues::StatusEnum.t(status) }

        let(:attributes) { valid_attributes.merge(status: status) }

        it 'creates an issue with a correct status' do
          expect(issue_attributes['status']).to eq translated_status
        end
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { invalid_attributes }

      it 'returns a failure response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns response in json format' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PATCH/PUT /issues/:id', response_format: :json do
    let!(:issue) { Issue.create(valid_attributes) }
    let(:status) { Issues::StatusEnum::IN_PROGRESS }

    let(:update_attributes) do
      {
        title: 'Updated issue',
        description: 'Updated description',
        status: status
      }
    end

    let(:translated_status) { Issues::StatusEnum.t(status) }

    before { put api_v1_issue_path(issue), params: { issue: attributes } }

    context 'with valid attributes' do
      let(:attributes) { update_attributes }
      let(:issue_attributes) { JSON.parse(response.body)['data']['attributes'] }

      it 'returns an updated issue in response' do
        expect(issue_attributes['title']).to eq update_attributes[:title]
        expect(issue_attributes['description'])
          .to eq update_attributes[:description]
        expect(issue_attributes['status']).to eq translated_status
      end

      it 'updates the issue' do
        issue.reload

        expect(issue.title).to eq update_attributes[:title]
        expect(issue.description).to eq update_attributes[:description]
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns response in json format' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { invalid_attributes }

      it 'returns a failure response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns response in json format' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE /issues/:id' do
    let!(:issue) { Issue.create(valid_attributes) }

    before { delete api_v1_issue_path(issue) }

    it 'returns an empty response' do
      expect(response.body).to be_empty
    end

    it 'returns a no content response' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
