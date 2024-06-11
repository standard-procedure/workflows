module Workflows
  # Convenience mix-in to return the included class's `name` as `to_s`
  module NameToS
    # @return [String]
    def to_s
      name
    end
  end
end
