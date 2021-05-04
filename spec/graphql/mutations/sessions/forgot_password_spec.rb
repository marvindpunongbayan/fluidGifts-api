require 'rails_helper'

describe Mutations::Sessions::ForgotPassword, type: :request do
  let(:email) { 'user@test.com' }
  let(:password) { 'Password1!' }
  let!(:user) { create(:user, password: password, email: email) }
  let(:email_field) { user.email }
  let(:query) do
    <<~GQL
      mutation {
        forgotPassword (
          input: {
            email: "#{email_field}"
          }
        ) {
          errors
        }
      }
    GQL
  end

  describe 'forgot_password' do
    context 'when there is a valid email' do
      subject do
        post '/graphql', params: { query: query }
        parse_graphql_response(response.body)['forgotPassword']
      end
      it { is_expected.to include 'errors' => [] }
    end

    context 'when there is an invalid parameter' do
      let!(:email_field) { 'aaa@test.com'  }
      subject do
        post '/graphql', params: { query: query }
        responses = parse_graphql_complete_response(response.body)['errors'].try(:first)
        responses.dig("message") if responses
      end
      it { is_expected.to eq('Invalid Email Address / Username')}
    end
  end
end
