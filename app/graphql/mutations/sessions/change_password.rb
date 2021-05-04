module Mutations
  module Sessions
    class ChangePassword < Mutations::BaseMutation
      graphql_name 'ChangePassword'
      argument :token, String, required: true
      argument :new_password, String, required: true

      field :errors, [String], null: true
      field :user, Types::UserType, null: true

      def resolve(token:,new_password:)
        payload, _header = Middlewares::Jwt::TokenDecryptor.decrypt(token)

        # Ennsure that the link is still active
        if payload
          if payload.dig("expire_at")
            if payload.dig("expire_at").to_time < Time.now
              raise GraphQL::ExecutionError.new("Link has been expired, please request another", options: {status: "INVALID", code: 401})
            end
          end
        else
          raise GraphQL::ExecutionError.new("Link has been expired, please request another", options: {status: "INVALID", code: 401})
        end

        # Ensure that the user_id is an object of User
        user = FluidGiftsApiSchema.object_from_id(payload.dig('user_id'))
        unless user
          raise GraphQL::ExecutionError.new("User not found", options: {status: "INVALID", code: 401})
        end
        unless user.is_a?(User)
          raise GraphQL::ExecutionError.new("Invalid parameter, '#{id}' is not related with user", options: {status: "INVALID", code: 401})
        end

        user = Middlewares::Users::Persistence.new(user).update({password: new_password})
        {
          errors: user.errors.full_messages,
          user: user
        }
      end
    end
  end
end
