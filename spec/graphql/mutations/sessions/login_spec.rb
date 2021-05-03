require 'rails_helper'

describe Mutations::Sessions::Login, type: :request do
  let(:email) { 'user@test.com' }
  let(:password) { 'Password1!' }
  let!(:user) { create(:user, password: password, email: email) }
  let(:login_email) { user.email }
  let(:login_password) { 'Password1!' }
  let(:login_query) do
    <<~GQL
      mutation {
        login (
          input: {
            email: "#{login_email}"
            password: "#{login_password}"
          }
        ) {
          token
          errors
          user {
            id
            name
            email
          }
        }
      }
    GQL
  end

  describe 'login' do
    before do
      post '/graphql', params: { query: login_query }
    end

    describe 'with wrong login details' do
      subject do
        responses = parse_graphql_complete_response(response.body)['errors'].try(:first)
        responses.dig("message") if response
      end
      context 'invalid email' do
        let(:login_email) { 'invalid@email.es' }

        it { is_expected.to eq('Invalid email or password')}
      end

      context 'invalid password' do
        let(:login_password) { 'password' }

        it { is_expected.to eq('Invalid email or password')}
      end
    end

    describe 'when login details are correct' do
      subject do
        parse_graphql_response(response.body)['login']
      end
      it { is_expected.to include 'errors' => [] }
      it { is_expected.to include 'token' }
      it { is_expected.to include 'user' }
    end
  end
end
