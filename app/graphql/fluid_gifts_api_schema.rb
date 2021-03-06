class FluidGiftsApiSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # rescue_from(ActiveRecord::Unauthorized) do |err, obj, args, ctx, field|
  #   GraphQL::ExecutionError.new("Unauthorized error", options: {status: :unauthorized, code: 401})
  # end
  # rescue_from ActiveRecord::RecordNotFound do |err, obj, args, ctx, field|
  #   GraphQL::ExecutionError.new("#{field.type.unwrap.graphql_name} not found", options: {status: "NOT_FOUND", code: 401})
  # end

  # rescue_from ActiveRecord::RecordInvalid do |exception|
  #   GraphQL::ExecutionError.new(exception.record.errors.full_messages.try(:first), options: {status: "INVALID", code: 401})
  # end

  def self.resolve_type(_type, object, _ctx)
    type_class = "::Types::#{object.class}Type".safe_constantize

    raise ArgumentError, "Cannot resolve type for class #{object.class.name}" unless type_class.present?

    type_class
  end

  def self.object_from_id(node_id)
    return unless node_id.present?

    record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(node_id)
    record_class = record_class_name.safe_constantize
    record_class&.find_by id: record_id
  end

  # We will use UniqId
  # def self.id_from_object(object)
  #   GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id)
  # end
end

