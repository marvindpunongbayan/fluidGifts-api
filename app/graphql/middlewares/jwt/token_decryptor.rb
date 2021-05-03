module Middlewares
  module Jwt
    class TokenDecryptor
      class << self
        def decrypt(token)
          begin
            JWT.decode(token, Rails.application.secrets.secret_key_base)
          rescue
            raise GraphQL::ExecutionError.new "Invalid token"
          end
        end
      end
    end
  end
end