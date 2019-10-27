# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Issue, type: :model do
  let(:valid_statuses) { Issues::StatusEnum.list }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_inclusion_of(:status).in_array valid_statuses }
end
