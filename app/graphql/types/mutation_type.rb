module Types
  class MutationType < BaseObject
    field :create_user, mutation: Mutations::Users::CreateUser
    field :signin_user, mutation: Mutations::Users::SignInUser
    #field :create_direct_upload, mutation: Mutations::CreateDirectUpload
  end
end