class FluidGiftsApiSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|    
    # Raise a graphql-friendly error with a custom message
    GraphQL::ExecutionError.new("#{field.type.unwrap.graphql_name} not found", extensions: {code: "NOT_FOUND"})
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    # Raise a graphql-friendly error with a custom message
    GraphQL::ExecutionError.new(exception.record.errors.full_messages.join("\n"), extensions: {code: "INVALID"})
  end

  def self.resolve_type(_type, object, _ctx)
    type_class = "::Types::#{object.class}Type".safe_constantize

    raise ArgumentError, "Cannot resolve type for class #{object.class.name}" unless type_class.present?

    type_class
  end

  def self.object_from_id(node_id, _ctx)
    return unless node_id.present?

    record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(node_id)
    record_class = record_class_name.safe_constantize
    record_class&.find_by id: record_id
  end

  def self.id_from_object(object, _type, _ctx)
    GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id)
  end
end

