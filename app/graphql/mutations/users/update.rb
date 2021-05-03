module Mutations
  module Users
    class Update < Mutations::AuthorisedMutation
      graphql_name 'UpdateUser'

      argument :id, String, required: false
      argument :name, String, required: true
      argument :role, Types::BaseEnums::UserRoleEnum, required: false

      field :errors, [String], null: true
      field :user, Types::UserType, null: true

      def resolve(params)
        user = Middlewares::Users::Persistence.new(current_user).update(params)
        {
          errors: user.errors.full_messages,
          user: user
        }
      end
    end
  end
end
