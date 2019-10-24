# frozen_string_literal: true

require 'support/logged_in_context'

shared_context 'when an issue exists' do
  let!(:issue) { create(:issue) }
end

shared_context 'when issue author is logged in' do
  include_context 'when logged in' do
    let(:user) { issue.author }
  end
end

shared_context 'when an issue of another author exists' do
  let(:another_author) { create :author }
  before { create :issue, author: another_author }
end

shared_context 'when attributes are invalid' do
  let(:attributes) do
    {
      title: ''
    }
  end
end
