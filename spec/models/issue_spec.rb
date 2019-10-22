# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Issue, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it do
    is_expected.to validate_inclusion_of(:status)
      .in_array Issues::StatusEnum.list
  end
end
