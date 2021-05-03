module Types
  class MutationType < BaseObject
    field :login, mutation: Mutations::Sessions::Login

    field :create_user, mutation: Mutations::Users::Create
    field :update_user, mutation: Mutations::Users::Update
    #field :delete_user, mutation: Mutations::User::Delete

    #field :create_direct_upload, mutation: Mutations::CreateDirectUpload
  end
end