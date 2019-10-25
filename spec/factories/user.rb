# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) do |unique_email_index|
      "user#{unique_email_index}@example.com"
    end

    password { 'password' }

    factory :author do
      role { Users::RoleEnum::AUTHOR }
    end

    factory :manager do
      role { Users::RoleEnum::MANAGER }
    end
  end
end
