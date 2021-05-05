require 'rails_helper'

describe Mutations::Sessions::Signup, type: :request do
  let(:admin) { create(:admin) }
  let(:name) { 'November Doom' }
  let(:email) { 'november@doom.com' }
  let(:password) { 'Password1!' }
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
        signup (
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

  describe 'signup' do
    subject do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
      parse_graphql_response(response.body)['signup']
    end

    context 'when there is a logged in user' do
      let!(:jwt_token) { generate_jwt_test_token(admin) }

      it { is_expected.to include 'user' => { 'name' => name } }
      it { is_expected.to include 'errors' => [] }
    end

    context 'when there is no user' do
      let!(:jwt_token) {}
      it { is_expected.to include 'user' => { 'name' => 'November Doom' } }
      it { is_expected.to include 'errors' => [] }
    end
  end
end
