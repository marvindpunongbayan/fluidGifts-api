module Middlewares
  module Jwt
    class TokenProvider
      def self.issue_token(payload)
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
      end
    end
  end
end