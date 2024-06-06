# frozen_string_literal: true

require "dry/struct"

module Workflows
  class Action < Dry::Struct
    include NameToS
    attribute :destination, Types::State
    attribute :outputs, Types::Array.of(Types::Coercible::String)
  end
end
