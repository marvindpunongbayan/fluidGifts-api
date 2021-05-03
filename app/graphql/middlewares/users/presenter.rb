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
    end
  end
end