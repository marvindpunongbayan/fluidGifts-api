module Mutations
  module Sessions
    class Signup < Mutations::BaseMutation
      graphql_name 'Signup'

      argument :name, String, required: true
      argument :email, String, required: true
      argument :password, String, required: true
      argument :role, Types::BaseEnums::UserRoleEnum, required: false

      field :errors, [String], null: true
      field :user, Types::UserType, null: true

      def resolve(params)
        user = Middlewares::Users::Persistence.new(current_user).create(params)
        {
          errors: user.errors.full_messages,
          user: user
        }
      end
    end
  end
end
