require 'rails_helper'

describe Mutations::Sessions::ChangePassword, type: :request do
  let(:user) { create(:user) }
  let(:new_password) {"Password1!"}
  let!(:jwt_token) { generate_jwt_forgot_password_test_token(user) }
  let(:query) do
    <<~GQL
      mutation {
        changePassword (
          input: {
            token: "#{jwt_token}"
            newPassword: "#{new_password}"
          }
        ) {
          user {name}
          errors
        }
      }
    GQL
  end

  describe 'change_password' do
    before do
      post '/graphql', params: { query: query }
    end

    describe 'when there is a valid token' do
      subject do
        parse_graphql_response(response.body)['changePassword']
      end
      it { is_expected.to include 'user' => { 'name' => user.name } }
      it { is_expected.to include 'errors' => [] }
    end

    describe 'when there is something wrong with the token' do
      subject do
        responses = parse_graphql_complete_response(response.body)['errors'].try(:first)
        responses.dig("message") if responses
      end
      context 'which is invalid' do
        let!(:jwt_token) { 'abde'  }
        it { is_expected.to eq('Invalid token')}
      end

      context 'which is expired' do
        let!(:jwt_token) {         
          invalid_hash = {
            user_id: GraphQL::Schema::UniqueWithinType.encode(user.class.name, user.id),
            role: user.role,
            expire_at: (Time.now - 1.minute).strftime("%Y-%m-%d %H:%M:%S")
          }
          Middlewares::Jwt::TokenProvider.issue_token(invalid_hash)
        }
        it { is_expected.to eq('Link has been expired, please request another')}
      end
      context 'which is invalid passing object' do
        let(:wrong_object) { create(:email_history) }
        let!(:jwt_token) {generate_jwt_forgot_password_test_token(wrong_object)}
        it { is_expected.to include 'Invalid parameter'}
      end
    end
  end
end
