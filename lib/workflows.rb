# frozen_string_literal: true

require "dry/types"
require "dry/configurable"

module Workflows
  extend Dry::Configurable

  module Types
    include Dry::Types()

    ID = Coercible::String.optional
    Name = Strict::String

    Card = Types.Interface(:id, :name, :state)
    Storage = Types.Interface(:create, :find, :where, :update, :delete)
    State = Types.Interface(:name, :perform_action)
    States = Types::Array.of(Types::State)
    Action = Types.Interface(:destination, :outputs)
    Actions = Types::Hash.map(Types::Coercible::String, Types::Action)
    Services = Types.Interface(:[], :resolve)
    Messages = Types.Interface(:publish, :subscribe)
    Workflow = Types.Interface(:states, :services, :messages)
  end

  class Error < StandardError; end

  require_relative "workflows/version"
  require_relative "workflows/name_to_s"
  require_relative "workflows/action"
  require_relative "workflows/state"
  require_relative "workflows/workflow"
  require_relative "workflows/card"

  setting :cards, default: InMemoryCards, reader: true
end
