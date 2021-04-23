require 'rails_helper'

module Mutations
  module Users
    RSpec.describe SignInUser, type: :request do
      describe '.resolve' do
        let!(:user) { create(:user, email: "user1@example.com", password: "123456")}
        let(:expected_response) do
          {
            "data" => {
              "signinUser" => {
                'token' => be_present,
                'user' => { 
                  'id' => user.id.to_s,
                  'name' => user.name,
                  'email' => user.email
                }
              }
            }
          }
        end

        it 'Mutation.signinUser: Login a user' do
          post '/graphql', params: { query: query(email: "user1@example.com", password: "123456") }
          data = JSON.parse(response.body)

          expect(data).to include(expected_response)
        end
      end

      def query(email: nil, password: nil)
        <<~GQL
          mutation {
            signinUser(
              credentials: {
                email: "#{email}",
                password: "#{password}"
              }
            ) {
              token
              user {
                id
                name
                email
              }
            }
          }
        GQL
      end
    end
  end
end