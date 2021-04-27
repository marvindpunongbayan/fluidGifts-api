module Types
  module BaseEnums
    class ImageVariant < Types::BaseEnum
      variants = {}
      variants[:thumb] = {resize_to_fill: [64, 64]}
      variants[:medium] = {resize_to_fill: [200, 200]}

      variants.each do |key, options|
        value key.to_s, options.map { |k, v| "#{k}: #{v}" }.join("\n"), value: options
      end
    end
  end
end