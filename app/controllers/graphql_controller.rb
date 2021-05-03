class GraphqlController < ApplicationController
  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = { current_user: current_user}
    result = FluidGiftsApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)

    render json: result
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [{ message: "Record was not found", code: 422, status: :unprocessable_entity}] }
  rescue ActiveRecord::ActiveRecordError => e
    render json: { errors: [{ message: e.record.errors.full_messages.try(:first), code: 422, status: :unprocessable_entity}] }
  rescue StandardError => e
    render json: { errors: [{ message: "#{e.message}", code: 422, status: :unprocessable_entity}] }
  # rescue Exception => e
  #   render json: { errors: [{ message: "Unexpected error!", code: 500, status: :unprocessable_entity}] }
  # rescue
  #   render json: { errors: [{ message: "Unexpected error!!!", code: 500, status: :unprocessable_entity}] }
  end

  private

  def current_user
    # Custom Tokenize
    # @current_user ||= AuthToken.user_from_token(params[:token])

    # JWT
    @current_user ||= Middlewares::Jwt::UserAuthenticator.validate(request.headers)
  rescue StandardError
    nil
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def error_handler(e)
    logger.error "error_handler: #{e.message}"
    #logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, code: 500, status: :unprocessable_entity}] }
  end
end
