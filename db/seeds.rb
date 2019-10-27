# frozen_string_literal: true

AUTHORS_NUMBER = 5
MANAGERS_NUMBER = 5
ISSUES_PER_AUTHOR = 15
PASSWORD = '123456'

# Create authors
AUTHORS_NUMBER.times do |author_order|
  User.create(
    email: "author+#{author_order}@example.com",
    password: PASSWORD,
    role: Users::RoleEnum::AUTHOR
  )
end

# Create issues
User.where(role: Users::RoleEnum::AUTHOR).each_with_index do |user, index|
  ISSUES_PER_AUTHOR.times do |issue_order|
    order = index * ISSUES_PER_AUTHOR + issue_order

    Issue.create(
      title: "Issue #{order}",
      description: "Description for Issue #{order}",
      status: Issues::StatusEnum::PENDING,
      author: user
    )
  end
end

# Create managers
MANAGERS_NUMBER.times do |manager_order|
  User.create(
    email: "manager+#{manager_order}@example.com",
    password: PASSWORD,
    role: Users::RoleEnum::MANAGER
  )
end
