require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      basePath: '/api/v1',
      securityDefinitions: {
        Bearer: {
          type: :apiKey,
          name: 'Authorization',
          in: :header
        }
      },
      definitions: {
        issue_object: {
          type: :object,
          required: %w[id attributes],
          properties: {
            id: { type: :string },
            attributes: {
              type: :object,
              required: %w[title description status],
              properties: {
                title: { type: :string },
                description: { type: :string },
                status: { type: :string }
              }
            }
          }
        }
      }
    }
  }
end
