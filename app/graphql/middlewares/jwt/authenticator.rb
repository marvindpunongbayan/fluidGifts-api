module Middlewares
  module Jwt
    class Authenticator
      def self.validate(request_headers)
        @request_headers = request_headers

        payload, _header = Middlewares::Jwt::TokenDecryptor.decrypt(token)

        FluidGiftsApiSchema.object_from_id(payload['user_id'])
      end

      def self.token
        return unless @request_headers['Authorization']
        @request_headers['Authorization'].split(' ').last
      end
    end
  end
end