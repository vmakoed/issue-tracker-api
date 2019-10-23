# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Signups', type: :request do
  shared_context 'when performing POST /signup request' do
    before { post api_v1_signup_path, params: { user: attributes } }
  end

  shared_context 'when signup attributes are valid' do
    let(:attributes) do
      {
        email: 'user@example.com',
        password: 'password'
      }
    end
  end

  shared_context 'when signup attributes are invalid' do
    let(:attributes) do
      {
        email: 'user@example.com'
      }
    end
  end

  describe 'POST /signups with valid attributes', response_format: :json do
    include_context 'when performing POST /signup request'
    include_context 'when signup attributes are valid'

    let(:user_id) { JSON.parse(response.body)['data']['id'] }
    let(:created_user) { User.find(user_id) }
    let(:user_attributes) { JSON.parse(response.body)['data']['attributes'] }

    it 'stores a created user' do
      expect(created_user).to be_present
    end

    it 'returns a created user in response' do
      expect(user_attributes['email']).to eq attributes[:email]
    end

    it 'assigns a correct password to a user' do
      expect(created_user.authenticate(attributes[:password])).to be_truthy
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:created)
    end
  end

  describe 'POST /signups with invalid attributes', response_format: :json do
    include_context 'when performing POST /signup request'
    include_context 'when signup attributes are invalid'

    it 'returns a failure response' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error' do
      expect(JSON.parse(response.body)['error']).not_to be_empty
    end
  end
end
