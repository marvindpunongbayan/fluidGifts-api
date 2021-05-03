module GraphQL
  module TokenGenerator
    def generate_jwt_test_token(user)
      Middlewares::Jwt::TokenProvider.issue_token(Middlewares::Users::Presenter.new(user).for_token)
    end
  end
end