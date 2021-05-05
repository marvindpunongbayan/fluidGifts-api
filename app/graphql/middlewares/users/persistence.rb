module Middlewares
  module Users
    class Persistence
      attr_reader :current_user

      def initialize(current_user = nil)
        @current_user = current_user
      end

      def create(params)
        user = User.create!(clean_params(params))
        user
      end

      def update(params)
        current_user.update!(clean_params(params))
        current_user
      end

      def clean_params(params)        
        params.reject{|k,v| v.nil? || v.blank? || ['id'].include?(k.to_s)}
      end
    end
  end
end