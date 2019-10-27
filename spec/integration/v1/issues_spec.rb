require 'swagger_helper'

require 'support/logged_in_context'

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
    get 'Fetch list of issues' do
      tags 'Issues'
      description "When logged in as an author, returns author's issues.
                  When logged in as a manager, returns all issues."
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :page,
                description: 'Used for pagination. '\
                             'Number of items per page: 25',
                in: :query,
                type: :integer,
                allowEmptyValue: true,
                default: 1
      parameter name: :status,
                description: 'Used for filtering issues list',
                in: :query,
                type: :string,
                enum: Issues::StatusEnum.list

      response '200', 'Issues list' do
        schema type: :object,
               required: %w[data],
               properties: {
                 data: {
                   type: :array,
                   items: { '$ref' => '#/definitions/issue' }
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

    post 'Create an issue' do
      tags 'Issues'
      description "You must be logged in as author to create an issue.
                   The issue is created with 'pending' status.
                   You cannot set status or manager_id to an issue (these "\
                  "parameters will be ignored)."
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :issue, in: :body, schema: {
        type: :object,
        required: %w[issue],
        properties: {
          issue: {
            type: :object,
            required: %w[title description],
            properties: {
              title: { type: :string },
              description: { type: :string }
            }
          }
        }
      }

      response '201', 'Created issue' do
        schema type: :object,
               required: %w[data],
               properties: {
                 data: { '$ref' => '#/definitions/issue' }
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
    get 'Fetch an issue' do
      tags 'Issues'
      description "When logged in as an author, you can only fetch your issues.
                   When logged in as a manager, you can fetch any issue."
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '200', 'Issue found' do
        schema type: :object,
               required: %w[data],
               properties: {
                 data: { '$ref' => '#/definitions/issue' }
               }

        let(:author) { create(:author) }
        let(:id) { create(:issue, author: author).id }

        include_context 'when author is logged in' do
          let(:user) { author }
        end

        run_test!
      end
    end

    put 'Update an issue' do
      tags 'Issues'
      description "When logged in as an author, you can only update title "\
                  "and description.
                  When logged in as a manager, you can only update status and "\
                  "manager_id.
                  You can only set a manager_id to your id (assign issue to "\
                  "self) or to an empty value (unassign).
                  You cannot update status to 'in_progress' or 'resolved' "\
                  "unless you have assigned an issue to yourself.
                  You cannot update manager_id to an empty value if its "\
                  "status is either 'in progress' of 'resolved'."
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer
      parameter name: :issue, in: :body, schema: {
        type: :object,
        required: %w[issue],
        properties: {
          issue: {
            type: :object,
            required: %w[title description],
            properties: {
              title: { type: :string },
              description: { type: :string },
              status: { type: :string, enum: Issues::StatusEnum.list },
              manager_id: { type: :integer, allow_empty_value: true }
            }
          }
        }
      }

      response '200', 'Updated issue' do
        schema type: :object,
               required: %w[data],
               properties: {
                 data: { '$ref' => '#/definitions/issue' }
               }

        let(:issue) do
          {
            issue: {
              title: 'New issue', description: 'Issue description'
            }
          }
        end

        let(:existing_issue) { create(:issue) }
        let(:id) { existing_issue.id }

        include_context 'when author is logged in' do
          let(:user) { existing_issue.author }
        end

        run_test!
      end
    end

    delete 'Delete an issue' do
      tags 'Issues'
      description "You can only delete an issue if you are logged in as its "\
                  "author."
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :id, in: :path, type: :integer

      response '204', 'Deleted issue' do
        let(:issue) do
          {
            issue: {
              title: 'New issue', description: 'Issue description'
            }
          }
        end

        let(:existing_issue) { create(:issue) }
        let(:id) { existing_issue.id }

        include_context 'when author is logged in' do
          let(:user) { existing_issue.author }
        end

        run_test!
      end
    end
  end
end
