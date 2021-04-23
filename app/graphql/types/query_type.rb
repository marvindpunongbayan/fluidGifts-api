module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :users,
          [Types::UserType],
          null: false,
          description: "Returns a list of users"

    def users
      User.all
    end

    field :users_with_image,
          [Types::UserType],
          null: false,
          description: "Returns a list of users with image"

    def users_with_image
      User.all.has_attached_image
    end
  end
end
