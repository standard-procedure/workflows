# frozen_string_literal: true

require "dry/struct"

module Workflows
  # An action that can be performed on a {Card} to change its {State}
  class Action < Dry::Struct
    include NameToS
    # @return [Workflows::State]
    attribute :destination, Types::State
    # @return [Array(String)]
    attribute :outputs, Types::Array.of(Types::Coercible::String)
  end
end
