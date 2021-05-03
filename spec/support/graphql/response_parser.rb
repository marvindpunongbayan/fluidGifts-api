module GraphQL
  module ResponseParser
    def parse_graphql_response(original_response)
      JSON.parse(original_response).delete('data')
    end

    def parse_graphql_complete_response(original_response)
      JSON.parse(original_response)
    end
  end
end
