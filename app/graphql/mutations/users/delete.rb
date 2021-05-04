module Mutations
  module Users
    class Delete < Mutations::AdminMutation
      graphql_name 'DeleteUser'

      argument :id, String, required: true

      field :errors, [String], null: true

      def resolve(id:)
        user = FluidGiftsApiSchema.object_from_id(id)
        unless user
          raise GraphQL::ExecutionError.new("User not found", options: {status: "INVALID", code: 401})
        end
        unless user.is_a?(User)
          raise GraphQL::ExecutionError.new("Invalid parameter, '#{id}' is not related with user", options: {status: "INVALID", code: 401})
        end
        if user.admin?
          raise GraphQL::ExecutionError.new("We are not allowed to delete an admin", options: {status: "INVALID", code: 401})
        end
        if user
          if user.destroy!
            {errors: []}
          else
            {errors: user.errors.full_messages}
          end
        else
          {errors: ["id: #{id}", 'User not found']}
        end
      end
    end
  end
end
