# frozen_string_literal: true

require 'rails_helper'

describe Mutations::Users::Update, type: :request do
  let(:user) { create(:user) }
  let(:name) { 'Entrophy' }

  let(:admin) { create(:admin) }
  let!(:jwt_token) { generate_jwt_test_token(admin) }
  let(:query) do
    <<~GQL
      mutation {
        updateUser (
          input: {
            id: "#{user.uniq_id}"
            name: "#{name}"
          }
        ) {
          user {
            name
          }
          errors
        }
      }
    GQL
  end

  describe 'update_user' do
    context 'admins can update any user' do
      let(:jwt_token) { generate_jwt_test_token(admin) }

      subject do
        post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
        parse_graphql_response(response.body)['updateUser']
      end

      it { is_expected.to include 'user' => { 'name' => 'Entrophy'} }
      it { is_expected.to include 'errors' => [] }
    end

    context 'users can update themselves' do
      let(:jwt_token) { generate_jwt_test_token(user) }

      before do
        post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{jwt_token}" }

        user.reload
      end

      it { expect(user.name).to eql 'Entrophy' }
    end
  end
end
