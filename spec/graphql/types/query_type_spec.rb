require "rails_helper"

RSpec.describe Types::QueryType do
  describe "users" do
    let!(:users) { create_pair(:user) }

    let(:query) do
      %(query {
        users {
          id
          name
          email
        }
      })
    end

    subject(:result) do
      FluidGiftsApiSchema.execute(query).as_json
    end

    it "should have a user" do
      users = result.dig("data", "users")
      count = users.present? ? users.count : 0
      expect(count).to_not be_zero
    end

    it "there's a missing or new query parameters (future-proofs)" do
      expect(result.dig("data", "users")).to match_array(
        users.map { |user| { 
          "id" => "#{user.id}", 
          "name" => "#{user.name}",
          "email" => "#{user.email}"
        }}
      )
    end
  end
end