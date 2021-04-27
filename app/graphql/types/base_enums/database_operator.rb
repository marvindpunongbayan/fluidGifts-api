module Types
  module BaseEnums
    class DatabaseOperator < Types::BaseEnum
      value 'OR', "ANY of name OR email match to a user will return as result"
      value 'AND', "REQUIRE name AND email match to a user will it return as result"
    end
  end
end