require 'swagger_helper'

describe 'Login API' do
  path '/login' do
    post 'Provides an authorization token' do
      tags 'Login'
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
              required: %w[email password]
            }
          }
        },
        required: %w[user]
      }

      response '200', 'Logged in successfully' do
        schema type: :object,
               required: %w[token],
               properties: {
                 token: { type: :string }
               }

        let(:user) do
          {
            user: {
              email: 'email@example.com', password: '123456', role: 'author'
            }
          }
        end

        before do
          create(:user, user[:user])
        end

        run_test!
      end
    end
  end
end
