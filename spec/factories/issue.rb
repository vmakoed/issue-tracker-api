# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    title { 'New issue' }
    description { 'Issue description' }

    association :author, factory: :author

    trait :with_manager do
      association :manager, factory: :manager
    end
  end
end
