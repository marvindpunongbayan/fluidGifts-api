module Mutations
  module Sessions
    class ForgotPassword < Mutations::BaseMutation
      graphql_name 'ForgotPassword'

      argument :email, String, required: true

      field :errors, [String], null: true

      def resolve(email:)
        user = User.find_by email: email
        
        unless user
          raise GraphQL::ExecutionError.new("Invalid Email Address / Username", options: {status: "INVALID", code: 401})
        end

        # Send notification and should have reset password link
        token = Middlewares::Jwt::TokenProvider.issue_token(Middlewares::Users::Presenter.new(user).for_forgot_password_token)
        SessionsMailer.forgot_password(user, token).deliver!
        
        {errors: []}
      end
    end
  end
end
