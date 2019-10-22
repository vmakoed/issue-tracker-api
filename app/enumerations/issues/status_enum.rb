# frozen_string_literal: true

module Issues
  class StatusEnum < EnumerateIt::Base
    associate_values :pending, :in_progress, :resolved
  end
end
