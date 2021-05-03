module Types
  class UserType < BaseObject
    field :id, String, null: false, method: :uniq_id
    field :name, String, null: false
    field :email, String, null: false
    field :role, String, null: false
    field :image_url, String, null: true, extensions: [Types::FieldExtensions::ImageUrlField]
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
