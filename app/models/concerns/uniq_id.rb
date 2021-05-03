require 'active_support/concern'
module UniqId
  extend ActiveSupport::Concern
  def uniq_id
    GraphQL::Schema::UniqueWithinType.encode(self.class.name, self.id)
  end
end
