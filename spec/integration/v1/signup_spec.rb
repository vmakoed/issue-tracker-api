require 'swagger_helper'

describe 'Signup API' do
  path '/signup' do
    post 'Register a user' do
      tags 'Signup'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        required: %w[user],
        properties: {
          user: {
            type: :object,
            required: %w[email password role],
            properties: {
              email: { type: :string },
              password: { type: :string },
              role: { type: :string, enum: Users::RoleEnum.list }
            }
          }
        }
      }

      response '201', 'User created' do
        schema type: :object,
               required: %w[data],
               properties: {
                 data: { '$ref' => '#/definitions/user' }
               }

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
