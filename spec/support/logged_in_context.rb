# frozen_string_literal: true

shared_context 'when logged in' do |args = {}|
  let(:role) { args.fetch(:role, Users::RoleEnum::AUTHOR) }
  let(:user) { create(:user, role: role) }

  let(:authorization_token) { 'authorization_token' }
  let(:authorization_headers) { { Authorization: authorization_token } }

  before do
    allow(JWT).to receive(:decode)
      .with(authorization_token, any_args)
      .and_return [user.id]
  end
end

shared_context 'when author is logged in' do
  include_context 'when logged in', role: Users::RoleEnum::AUTHOR
end

shared_context 'when manager is logged in' do
  include_context 'when logged in', role: Users::RoleEnum::MANAGER
end
