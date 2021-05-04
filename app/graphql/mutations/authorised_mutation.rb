module Mutations
  class AuthorisedMutation < BaseMutation
    def initialize(options)
      super(options)

      authorise_user
    end

    protected

    def authorise_user
      return true if current_user.present?
      raise GraphQL::ExecutionError.new("Invalid user, please try again later", options: {status: "INVALID", code: 401})
    end

    def current_user
      context[:current_user]
    end
  end
end
