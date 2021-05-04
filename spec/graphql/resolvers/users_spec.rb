require 'rails_helper'

describe Resolvers::Users, type: :request do
  let(:email) { 'user@test.com' }
  let(:password) { 'Password1!' }
  let(:user) { create(:user, password: password, email: email) }
  let!(:jwt_token) { generate_jwt_test_token(user) }
  let(:login_email) { user.email }
  let(:login_password) { 'Password1!' }

  let(:non_user_query) do
    <<~GQL
      query {
        users {
          id
          name
        }
      }
    GQL
  end
  let(:find_by_name) do
    <<~GQL
      query {
        users(
          filter: {
            nameContains: "#{query_string}"
          }
        ) {
          name
        }
      }
    GQL
  end
  let(:find_by_email) do
    <<~GQL
      query {
        users(
          filter: {
            emailContains: "#{query_string}"
          }
        ) {
          name
          email
        }
      }
    GQL
  end

  let!(:in_love) { create(:user, name: 'In Love') }
  let!(:in_gain) { create(:user, name: 'In Gain') }
  let!(:power_rest) { create(:user, name: 'Power Rest') }

  describe 'users' do
    before do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
    end

    subject { parse_graphql_response(response.body)['users'] }

    context 'filtered by name' do
      let(:query) { find_by_name }
      let(:query_string) { 'In' }

      it { is_expected.to include 'name' => in_love.name }
      it { is_expected.to include 'name' => in_gain.name }
      it { is_expected.to_not include 'name' => power_rest.name }
    end

    context 'filtered by email' do
      let(:query) { find_by_email }
      let(:query_string) { power_rest.email }

      it { is_expected.to include 'name' => power_rest.name, "email" => power_rest.email }
      it { is_expected.to_not include 'name' => in_love.name, "email" => in_love.email }
    end
  end

  describe 'non-users' do
    let!(:jwt_token) { }
    let(:query) {non_user_query}
    subject do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
      responses = parse_graphql_complete_response(response.body)['errors'].try(:first)
      responses.dig("message") if responses
    end
    it { is_expected.to eq('User not signed in')}
  end
end
