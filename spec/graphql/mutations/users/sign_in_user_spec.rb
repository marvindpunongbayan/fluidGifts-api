# require 'rails_helper'

# module Mutations
#   module Users
#     RSpec.describe SignInUser, type: :request do
#       let!(:expected_keys) do
#         # if there's changes on Types::UserType fields, it should raise an error for Future-Proofs
#         ["id", "name", "email", "imageUrl", "createdAt", "updatedAt"]
#       end
#       describe '.resolve' do
#         let!(:user) { create(:user, email: "user1@example.com", password: "AAaa11@@")}
#         let!(:expected_response) do
#           user_hashes = Hash.new
#           expected_keys.each do |expected_key|
#             user_hashes["#{expected_key}"] = (
#               if ["imageUrl"].include?(expected_key)
#                 user.send(expected_key.underscore.gsub("_url", "")).present? ? be_present : eq(nil)
#               else
#                 ["id", "createdAt", "updatedAt"].include?(expected_key) ? be_present : user.send(expected_key.underscore)
#               end
#             )
#           end
#           {
#             "data" => {
#               "signinUser" => {
#                 'token' => be_present,
#                 'user' => user_hashes
#               }
#             }
#           }
#         end

#         it 'Mutation.signinUser: Login a user' do
#           post '/graphql', params: { query: query(email: "user1@example.com", password: "AAaa11@@") }
#           data = JSON.parse(response.body)

#           expect(data).to include(expected_response)
#         end
#       end

#       def query(email: nil, password: nil)
#         <<~GQL
#           mutation {
#             signinUser(
#               credentials: {
#                 email: "#{email}",
#                 password: "#{password}"
#               }
#             ) {
#               token
#               user {
#                 #{expected_keys.map{|x| ["imageUrl"].include?(x) ? "#{x}(variant: medium)" : x}.join("\n")}
#               }
#             }
#           }
#         GQL
#       end
#     end
#   end
# end