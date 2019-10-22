# frozen_string_literal: true

RSpec.configure do |config|
  config.after(:example, type: :request, response_format: :json) do
    expect(response.content_type).to eq('application/json; charset=utf-8')
  end
end
