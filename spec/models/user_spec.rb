# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(email: 'user@example.com', password: 'password')
  end

  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to have_secure_password }
end
