module Types
  module FieldExtensions
    class ImageUrlField < GraphQL::Schema::FieldExtension
      def apply
        field.argument(:variant, Types::BaseEnums::ImageVariant, required: false)
      end

      def resolve(object:, **_rest)
        attachment = options&.[](:attachment) || field.original_name.to_s.sub(/_url$/, "")
        object.object.send(attachment)
      end

      def after_resolve(value:, arguments:, **_rest)
        return if value.nil?
        if (variant = arguments.dig(:variant)) && (variant_value = value.variant(variant))
          #value.record.send(value.name).variant(variant).processed.url
          #Rails.application.routes.url_helpers.url_for(variant_value)
          variant_value.url
        end
      end
    end
  end
end