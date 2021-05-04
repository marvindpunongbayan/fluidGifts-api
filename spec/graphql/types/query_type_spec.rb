# require "rails_helper"

# RSpec.describe Types::QueryType do
#   let!(:expected_keys) do
#     # if there's changes on Types::UserType fields, it should raise an error for Future-Proofs
#     ["id", "name", "email", "role", "imageUrl", "createdAt", "updatedAt"]
#   end
#   describe "users" do
#     let!(:users) { create_pair(:user) }
#     let!(:query) do
#       %(query {
#         users {#{expected_keys.map{|x| ["imageUrl"].include?(x) ? "#{x}(variant: medium)" : x}.join("\n")}}
#       })
#     end
#     subject(:result) do
#       FluidGiftsApiSchema.execute(query).as_json
#     end

#     it "should have a user" do
#       users = result.dig("data", "users")
#       count = users.present? ? users.count : 0
#       expect(count).to_not be_zero
#     end

#     it "should match the return json" do
#       expect(result.dig("data", "users")).to include(
#         users.map do |user|
#           h = Hash.new
#           expected_keys.each do |expected_key|
#             h["#{expected_key}"] = (
#               if ["imageUrl"].include?(expected_key)
#                 user.send(expected_key.underscore.gsub("_url", "")).present? ? be_present : eq(nil)
#               else
#                 ["id", "createdAt", "updatedAt"].include?(expected_key) ? be_present : user.send(expected_key.underscore)
#               end
#             )
#           end
#           h
#         end.first
#       )
#     end

#     it "there's a missing or new parameters" do
#       expect(Types::UserType.fields.keys).to match_array(expected_keys)
#     end
#   end

#   describe "uers with image" do
#     before(:each) do
#       @user = create(:user)
#       @user.image.attach(
#         io: File.open(Rails.root.join('spec', 'factories', 'images', 'test.png')),
#         filename: 'test.png',
#         content_type: 'image/png'
#       )
#     end

#     let!(:query) do
#       %(query {
#         users (
#           filter: {
#             withImage: true
#           }
#         ) {
#           #{expected_keys.map{|x| ["imageUrl"].include?(x) ? "#{x}(variant: medium)" : x}.join("\n")}
#         }
#       })
#     end
#     subject(:result) do
#       FluidGiftsApiSchema.execute(query).as_json
#     end

#     it "is attached" do
#       expect(@user.image).to be_attached
#     end

#     it "should have a user with image" do
#       users = result.dig("data", "users")
#       count = users.present? ? users.count : 0
#       expect(count).to_not be_zero
#     end
#   end
# end