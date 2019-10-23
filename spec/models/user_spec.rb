# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(email: 'user@xample.com', password: 'password') }

  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to have_secure_password }
end
