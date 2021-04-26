module Types
  class UserType < Types::BaseNode
    field :name, String, null: false
    field :email, String, null: false
    field :image_url, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def image_url
      if object.image.present?
        #object.image.url
        #Rails.application.routes.url_helpers.rails_blob_url(object.image)
        object.image.variant(resize_to_limit: [100, 100]).processed.url
      end
    end
  end
end
