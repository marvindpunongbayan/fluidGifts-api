module Resolvers
  class Base < GraphQL::Schema::Resolver
    #attr_reader :db_query
    def initialize(options)
      super(options)

      authorize_user
    end

    protected
    def authorize_user
      return true if current_user.present?
      raise GraphQL::ExecutionError.new("User not signed in", options: {status: "INVALID", code: 401})
    end

    def current_user
      context[:current_user]
    end
  end
end
