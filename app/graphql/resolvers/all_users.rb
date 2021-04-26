module Resolvers
  class AllUsers < GraphQL::Schema::Resolver
    class UserFilter < Types::BaseInputObject
      argument :name_contains, String, required: false
      argument :email_contains, String, required: false
    end

    class UserOperator < ::Types::BaseEnum
      value 'OR'
      value 'AND'
    end

    argument :filter, UserFilter, required: false
    argument :filterOperator, UserOperator, required: false
    argument :limit, Integer, required: false
    argument :offset, Integer, required: false
    argument :with_image, Boolean, required: false
    
    type [Types::UserType], null: true

    def resolve(filter: nil, filterOperator: "OR", limit: nil, offset: nil, with_image: false)
      users = User.all
      if filter.present?
        where_conditions = []
        where_conditions << "users.name LIKE '%#{filter[:name_contains]}%'" if filter[:name_contains].present?
        where_conditions << "users.email LIKE '%#{filter[:email_contains]}%'" if filter[:email_contains].present?
        if where_conditions.any?
          users = users.where(where_conditions.join(" #{filterOperator} "))
        end
      end
      users = users.has_attached_image if with_image
      users = users.limit(limit) if limit
      users = users.offset(offset) if offset
      users
    end
  end
end
