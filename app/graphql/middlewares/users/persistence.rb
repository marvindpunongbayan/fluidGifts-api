module Middlewares
  module Users
    class Persistence
      attr_reader :current_user

      def initialize(current_user = nil)
        @current_user = current_user
      end

      def create(params)
        return current_user if current_user.present?

        User.create!(
          name: params[:name],
          email: params[:email],
          password: params[:password],
          role: params[:role]
        )
      end

      def update(params)
        current_user.update!(name: params[:name])
        current_user
      end
    end
  end
end