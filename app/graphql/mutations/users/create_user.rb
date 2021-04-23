module Mutations
  module Users
    class CreateUser < BaseMutation
      class AuthProviderSignupData < Types::BaseInputObject
        argument :credentials, Types::AuthProviderCredentialsInput, required: false
      end

      argument :name, String, required: true
      argument :auth_provider, AuthProviderSignupData, required: false
      argument :image, String, required: false

      field :id, ID, null: false
      field :name, String, null: true
      field :email, String, null: true

      def resolve(name: nil, image: nil, auth_provider: nil)
        user = User.create!(
          name: name,
          email: auth_provider&.[](:credentials)&.[](:email),
          password: auth_provider&.[](:credentials)&.[](:password)
        )
        if image.present?
          user.image.attach(data: image)
        end
        user
      end
    end
  end
end
