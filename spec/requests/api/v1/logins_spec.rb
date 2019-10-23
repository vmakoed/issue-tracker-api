# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logins', type: :request do
  let(:user_params) { { email: 'example.com', password: 'password' } }
  let(:token) { 'token' }

  before do
    User.create(user_params)
    allow(JWT).to receive(:encode).and_return token
  end

  shared_context 'when performing POST /login request' do
    before { post api_v1_login_path, params: { user: attributes } }
  end

  shared_context 'when login attributes are valid' do
    let(:attributes) { user_params }
  end

  describe 'POST /login with valid attributes', response_format: :json do
    include_context 'when performing POST /login request'
    include_context 'when login attributes are valid'

    it 'returns a token in response' do
      expect(JSON.parse(response.body)['token']).to eq token
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:ok)
    end
  end

  shared_context 'when login attributes are invalid' do
    let(:attributes) { { email: 'example.com', password: '123456' } }
  end

  describe 'POST /login with invalid attributes', response_format: :json do
    include_context 'when performing POST /login request'
    include_context 'when login attributes are invalid'

    it 'returns a failure response' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end
end
