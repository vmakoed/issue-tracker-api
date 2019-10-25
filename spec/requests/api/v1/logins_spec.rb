# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logins', type: :request do
  let(:email) { 'user@example.com' }
  let(:valid_password) { 'password' }
  let(:user_params) { { email: email, password: valid_password } }
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

  describe 'POST /login with valid attributes',
           response_format: :json,
           response_status: :success do
    include_context 'when performing POST /login request'
    include_context 'when login attributes are valid'

    it 'returns a token in response' do
      expect(JSON.parse(response.body)['token']).to eq token
    end
  end

  shared_context 'when login attributes are invalid' do
    let(:attributes) { { email: email, password: '123456' } }
  end

  describe 'POST /login with invalid attributes',
           response_format: :json,
           response_status: :unprocessable_entity do
    include_context 'when performing POST /login request'
    include_context 'when login attributes are invalid'

    it 'returns error in the response' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end
end
