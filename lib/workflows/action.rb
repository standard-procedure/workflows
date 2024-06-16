# frozen_string_literal: true

require "dry/struct"

module Workflows
  # An action that can be performed on a {Card} to change its {State}
  class Action < Dry::Struct
    include NameToS
    # @return [String]
    attribute :name, Types::String
    # @return [String]
    attribute :description, Types::String.default("")
    # @return [String]
    attribute :colour, Types::Colour
    # @return [String]
    attribute :prompt, Types::String.optional
    # @return [String]
    attribute :move_to, Types::String
    # @return [Array<String>]
    attribute :automations, Types::Array.of(Types::String)
  end
end
