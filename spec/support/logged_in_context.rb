# frozen_string_literal: true

shared_context 'when user is logged in' do
  let(:user) do
    User.create(email: 'user@example.com', password: 'password')
  end

  let(:authorization_token) { 'authorization_token' }
  let(:authorization_headers) { { Authorization: authorization_token } }

  before do
    allow(JWT).to receive(:decode)
      .with(authorization_token, any_args)
      .and_return [user.id]
  end
end
