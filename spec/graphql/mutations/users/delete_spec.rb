require 'rails_helper'

describe Mutations::Users::Delete, type: :request do
  let(:user) { create(:user) }
  let!(:admin) { create(:admin) }
  let!(:jwt_token) { generate_jwt_test_token(admin) }
  let(:query) do
    <<~GQL
      mutation {
        deleteUser (
          input: {
            id: "#{user.uniq_id}"
          }
        ) {
          errors
        }
      }
    GQL
  end

  describe 'delete_user' do
    subject do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
      parse_graphql_response(response.body)['deleteUser']
    end

    context 'when there is a valid user to delete' do
      it { is_expected.to include 'errors' => [] }
    end
  end
end
