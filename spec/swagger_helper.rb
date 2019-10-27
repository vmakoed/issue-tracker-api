require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        description: 'An issue-tracking API.',
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
        user: {
          type: :object,
          required: %w[id attributes],
          properties: {
            id: { type: :string },
            attributes: {
              type: :object,
              required: %w[email role],
              properties: {
                email: { type: :string },
                role: { type: :string, enum: Users::RoleEnum.list }
              }
            }
          }
        },
        issue: {
          type: :object,
          required: %w[id attributes relationships],
          properties: {
            id: { type: :string },
            attributes: {
              type: :object,
              required: %w[title description status],
              properties: {
                title: { type: :string },
                description: { type: :string },
                status: { type: :string, enum: Issues::StatusEnum.list }
              }
            },
            relationships: {
              type: :object,
              required: %w[author manager],
              properties: {
                author: {
                  type: :object,
                  required: %w[data],
                  properties: {
                    data: {
                      type: :object,
                      required: %w[id],
                      properties: {
                        id: { type: :string }
                      }
                    }
                  }
                },
                manager: {
                  type: :object,
                  properties: {
                    data: {
                      type: :object,
                      'x-nullable': true,
                      required: %w[id],
                      properties: {
                        id: { type: :string }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
end
