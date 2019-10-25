# frozen_string_literal: true

module Users
  class RoleEnum < EnumerateIt::Base
    associate_values :author, :manager
  end
end
