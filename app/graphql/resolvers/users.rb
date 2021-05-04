module Resolvers
  class Users < Resolvers::Base
    class UserFilter < Types::BaseInputObject
      argument :name_contains, String, required: false, description: "Find all string matches"
      argument :email_contains, String, required: false, description: "Find all string matches"
      argument :with_image, Boolean, required: false, description: "Returns users with attached image"
    end

    argument :filter, UserFilter, required: false
    argument :filterOperator, Types::BaseEnums::DatabaseOperator, required: false
    argument :limit, Integer, required: false, description: "Max number of results"
    argument :offset, Integer, required: false, description: "Skip number of results"
    
    type [Types::UserType], null: true

    def resolve(filter: nil, filterOperator: "OR", limit: nil, offset: nil)

      users = User.all
      if filter.present?
        where_conditions = []
        where_conditions << "users.name LIKE '%#{filter[:name_contains]}%'" if filter[:name_contains].present?
        where_conditions << "users.email LIKE '%#{filter[:email_contains]}%'" if filter[:email_contains].present?
        if where_conditions.any?
          users = users.where(where_conditions.join(" #{filterOperator} "))
        end
        if defined?(filter[:with_image])
          if filter[:with_image]
            users = users.has_attached_image
          else
            users = users.without_attached_image
          end
        end
      end
      users = users.limit(limit) if limit
      users = users.offset(offset) if offset
      users
    end
  end
end
