module Types
  class UserType < Types::BaseNode
    field :name, String, null: false
    field :email, String, null: false
    field :image_url, String, null: true, extensions: [Types::FieldExtensions::ImageUrlField]
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # field :image_url, String, null: true do
    #   argument :variant, Types::BaseEnums::ImageVariant, required: false
    # end

    # def image_url(variant: nil)
    #   if object.image.present?
    #     image = object.image.variant(variant) if variant
    #     Rails.application.routes.url_helpers.url_for(image)
    #   end
    # end
  end
end
