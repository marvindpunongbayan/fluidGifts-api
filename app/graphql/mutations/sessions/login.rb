module Mutations
  module Sessions
    class Login < Mutations::BaseMutation
      graphql_name 'LoginUser'

      argument :email, String, required: true
      argument :password, String, required: true

      field :errors, [String], null: true
      field :token, String, null: true
      field :user, Types::UserType, null: true

      def resolve(email:, password:)
        user = User.find_by email: email

        # ensures we have the correct user
        unless user && user.authenticate(password)
          raise GraphQL::ExecutionError.new("Invalid email or password", options: {status: "INVALID", code: 401})
        end

        token = Middlewares::Jwt::TokenProvider.issue_token(Middlewares::Users::Presenter.new(user).for_token)
        { token: token, user: user, errors: [] }
      end
    end
  end
end
