module Types
  module BaseEnums
    class UserRoleEnum < Types::BaseEnum
      value 'Customer', value: 'customer'
      value 'Admin', value: 'admin'
      value 'Vendor', value: 'vendor'
    end
  end
end
