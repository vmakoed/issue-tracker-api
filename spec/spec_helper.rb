# frozen_string_literal: true

RSpec.configure do |config|
  config.after(:example, type: :request, response_format: :json) do |example|
    expect(response.content_type).to eq('application/json; charset=utf-8')

    response_status = example.metadata[:response_status]

    if response_status.present?
      expect(response).to have_http_status(response_status)
    end
  end
end
