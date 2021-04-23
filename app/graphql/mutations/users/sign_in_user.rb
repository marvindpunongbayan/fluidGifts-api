module Mutations
  module Users
    class SignInUser < BaseMutation
      null true

      argument :credentials, Types::AuthProviderCredentialsInput, required: false

      field :token, String, null: true
      field :user, Types::UserType, null: true

      def resolve(credentials: nil)
        # basic validation
        unless credentials
          return GraphQL::ExecutionError.new("Please input your credentials.", options: {status: "INVALID", code: 401})
        end

        user = User.find_by email: credentials[:email]

        # ensures we have the correct user
        unless user        
          return GraphQL::ExecutionError.new("Invalid user, please register your account.", options: {status: "INVALID", code: 401})
        end

        # ensures there's a valid password
        unless user.authenticate(credentials[:password])
          return GraphQL::ExecutionError.new("Invalid credentials, please check your details.", options: {status: "INVALID", code: 401})
        end

        token = AuthToken.crypt.encrypt_and_sign("user-id:#{ user.id }")

        { user: user, token: token }
      end
    end
  end
end