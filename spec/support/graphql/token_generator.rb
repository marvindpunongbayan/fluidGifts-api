module GraphQL
  module TokenGenerator
    def generate_jwt_test_token(user)
      Middlewares::Jwt::TokenProvider.issue_token(Middlewares::Users::Presenter.new(user).for_token)
    end
    def generate_jwt_forgot_password_test_token(user)
      Middlewares::Jwt::TokenProvider.issue_token(Middlewares::Users::Presenter.new(user).for_forgot_password_token)
    end
  end
end