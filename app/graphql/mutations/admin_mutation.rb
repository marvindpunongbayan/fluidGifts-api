module Mutations
  class AdminMutation < AuthorisedMutation
    def initialize(options)
      super(options)
      authorise_admin
    end

    protected
    def authorise_admin
      raise GraphQL::ExecutionError, "You don't have privilege to do this action" unless context[:current_user].admin?
    end
  end
end
