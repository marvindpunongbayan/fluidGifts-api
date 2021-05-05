module Types
  class MutationType < BaseObject
    field :login, mutation: Mutations::Sessions::Login
    field :signup, mutation: Mutations::Sessions::Signup
    field :forgot_password, mutation: Mutations::Sessions::ForgotPassword
    field :forgot_password_checker, mutation: Mutations::Sessions::ForgotPasswordChecker
    field :change_password, mutation: Mutations::Sessions::ChangePassword

    field :create_user, mutation: Mutations::Users::Create
    field :update_user, mutation: Mutations::Users::Update
    field :delete_user, mutation: Mutations::Users::Delete

    #field :create_direct_upload, mutation: Mutations::CreateDirectUpload
  end
end