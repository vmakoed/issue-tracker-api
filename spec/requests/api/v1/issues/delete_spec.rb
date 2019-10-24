# frozen_string_literal: true

require 'rails_helper'
require 'support/issues/shared_contexts'

RSpec.describe 'Issues', type: :request do
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
