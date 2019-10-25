# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(email: 'user@example.com', password: 'password')
  end

  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  describe 'validates email format' do
    subject do
      described_class.new(email: email, password: 'password')
    end

    context 'when email is correct' do
      let(:email) { 'user@example.com' }

      it { is_expected.to be_valid }
    end

    context 'when email is incorrect' do
      let(:email) { 'userexample.com' }

      it { is_expected.not_to be_valid }
    end
  end
end
