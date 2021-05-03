# require "rails_helper"

# module Mutations
#   module Users
#     RSpec.describe CreateUser, type: :request do
#       describe "POST /graphql create_user with proper data " do
#         let!(:user_attrs) { attributes_for(:user) }

#         let!(:query) do
#           %(mutation{
#             createUser(
#               name: "#{user_attrs[:name]}",
#               authProvider:{
#                 credentials: {
#                   email: "#{user_attrs[:email]}",
#                   password: "#{user_attrs[:password]}"
#                 }
#               }
#             )
#             {
#               id
#               name
#               email
#             }
#           })
#         end

#         let!(:expected_response) do
#           {
#             "data" => {
#               "createUser" => {
#                 "id" => be_present,
#                 "name" => user_attrs[:name],
#                 "email" => user_attrs[:email]
#               }
#             }
#           }
#         end

#         it 'Create a user' do
#           post '/graphql', params: { query: query }
#           expect(User.count).to eq(1)
#         end
#         it "should return these parameters" do
#           post '/graphql', params: { query: query }
#           expect(JSON.parse(response.body)).to include(expected_response)
#         end
#       end
#     end
#   end
# end