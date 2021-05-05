require 'rails_helper'

describe Mutations::Users::Create, type: :request do
  let(:user) { create(:user) }
  let(:name) { 'November Doom' }
  let(:email) { 'november@doom.com' }
  let(:password) { 'Password1!' }
  let(:admin) { create(:admin) }
  let!(:jwt_token) { generate_jwt_test_token(admin) }
  let(:result_info) do
    <<~RESULT
      {
        name
      }
    RESULT
  end
  let(:query) do
    <<~GQL
      mutation {
        createUser (
          input: {
            name: "#{name}"
            email: "#{email}"
            password: "#{password}"
          }
        ) {
          user #{result_info}
          errors
        }
      }
    GQL
  end

  describe 'create_user' do
    context 'when there is a logged in admin user' do
      let!(:jwt_token) { generate_jwt_test_token(admin) }

      subject do
        post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
        parse_graphql_response(response.body)['createUser']
      end
      it { is_expected.to include 'user' => { 'name' => name} }
      it { is_expected.to include 'errors' => [] }
    end
    context 'when there is a logged in non-admin user' do
      let(:non_admin) { create(:user) }
      let!(:jwt_token) { generate_jwt_test_token(non_admin) }

      subject do
        post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
        responses = parse_graphql_complete_response(response.body)['errors'].try(:first)
        responses.dig("message") if responses
      end
      it { is_expected.to eq("You don't have privilege to do this action")}
    end
    context 'when there is no logged-in user' do
      let!(:jwt_token) { }
      subject do
        post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
        responses = parse_graphql_complete_response(response.body)['errors'].try(:first)
        responses.dig("message") if responses
      end
      it { is_expected.to eq("Invalid user, please try again later")}
    end
  end
end
