require 'swagger_helper'

describe 'Issues API' do
  shared_context 'when author is logged in' do
    let(:token) { 'token' }
    let(:'Authorization') { token }
    let(:user) { create(:author) }

    before do
      allow(JWT).to receive(:decode).with(token, any_args).and_return [user.id]
    end
  end

  path '/issues' do
    get 'Returns a list of issues' do
      tags 'Issues'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :page,
                in: :query,
                type: :integer,
                allowEmptyValue: true,
                default: 1
      parameter name: :status, in: :query, type: :string, allowEmptyValue: true

      response '200', 'Issues list' do
        schema type: :object,
               required: %w[data],
               properties: {
                 data: {
                   type: :array,
                   items: { '$ref' => '#/definitions/issue_object' }
                 }
               }

        let(:author) { create(:author) }
        let(:page) { nil }
        let(:status) { nil }

        before do
          create(:issue, author: author)
        end

        include_context 'when author is logged in' do
          let(:user) { author }
        end


        run_test!
      end
    end

    post 'Creates an issue' do
      tags 'Issues'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :issue, in: :body, schema: {
        type: :object,
        properties: {
          issue: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string }
            },
            required: %w[title description]
          },
          required: %w[issue]
        },
        required: %w[issue]
      }

      response '201', 'Created issue' do
        schema type: :object,
               required: %w[data],
               properties: {
                 data: { '$ref' => '#/definitions/issue_object' }
               }

        let(:issue) do
          {
            issue: {
              title: 'New issue', description: 'Issue description'
            }
          }
        end

        include_context 'when author is logged in'

        run_test!
      end
    end
  end

  path '/issues/{id}' do
    get 'Returns the issue' do
      tags 'Issues'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'Issue found' do
        schema type: :object,
               required: %w[data],
               properties: {
                 data: { '$ref' => '#/definitions/issue_object' }
               }

        let(:author) { create(:author) }
        let(:id) { create(:issue, author: author).id }

        include_context 'when author is logged in' do
          let(:user) { author }
        end

        run_test!
      end
    end
  end
end
