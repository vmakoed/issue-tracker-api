require 'swagger_helper'

describe 'Signup API' do
  path '/signup' do
    post 'Registers a user' do
      tags 'Signup'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              role: { type: :string },
              required: %w[email password role]
            }
          }
        },
        required: %w[user]
      }

      response '201', 'User created' do
        let(:user) do
          {
            user: {
              email: 'email@example.com', password: '123456', role: 'author'
            }
          }
        end

        run_test!
      end
    end
  end
end