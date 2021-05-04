module Mutations
  module Users
    class Update < Mutations::AuthorisedMutation
      graphql_name 'UpdateUser'

      argument :id, String, required: false
      argument :name, String, required: true
      argument :password, String, required: false
      argument :role, Types::BaseEnums::UserRoleEnum, required: false

      field :errors, [String], null: true
      field :user, Types::UserType, null: true

      def resolve(params)
        id = params[:id]
        if id.present?
          user = FluidGiftsApiSchema.object_from_id(id)
          unless user
            raise GraphQL::ExecutionError.new("User not found", options: {status: "INVALID", code: 401})
          end
          unless user.is_a?(User)
            raise GraphQL::ExecutionError.new("Invalid parameter, '#{id}' is not related with user", options: {status: "INVALID", code: 401})
          end
          unless user.editable?(current_user)
            raise GraphQL::ExecutionError.new("You have no privilege to do edit a different user.", options: {status: "INVALID", code: 401})
          end
          user = Middlewares::Users::Persistence.new(user).update(params)
          {
            errors: user.errors.full_messages,
            user: user
          }
        else
          user = Middlewares::Users::Persistence.new(current_user).update(params)
          {
            errors: user.errors.full_messages,
            user: user
          }
        end
      end
    end
  end
end
