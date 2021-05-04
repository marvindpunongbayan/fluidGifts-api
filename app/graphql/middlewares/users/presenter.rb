module Middlewares
  module Users
    class Presenter
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def for_token
        {
          user_id: GraphQL::Schema::UniqueWithinType.encode(user.class.name, user.id),
          role: user.role
        }
      end

      def for_reset_password_token
        {
          user_id: GraphQL::Schema::UniqueWithinType.encode(user.class.name, user.id),
          role: user.role,
          expire_at: (Time.now + 15.minute).strftime("%Y-%m-%d %H:%M:%S")
        }
      end
    end
  end
end