# frozen_string_literal: true

require "dry/types"
require "dry/configurable"
require "plumbing"

module Workflows
  extend Dry::Configurable

  module Types
    include Dry::Types()

    ID = Coercible::String.optional
    Name = Strict::String
    Colour = Types::String.default("primary").enum("light", "dark", "primary", "secondary", "success", "warning", "danger", "info")
    Card = Types.Interface(:id, :name, :state)
    State = Types.Interface(:name, :perform_action)
    StateType = Types::String.default("in_progress").enum("initial", "in_progress", "completed")
    States = Types::Array.of(Types::State)
    CompletionBy = Types::String.default("anyone").enum("anyone", "everyone")
    Action = Types.Interface(:name, :colour, :prompt, :move_to, :automations)
    Actions = Array.of(Action)
    Operation = Types.Interface(:call)
    Services = Types::Hash.map(Types::Coercible::String, Types::Operation)
    Messages = Types.Interface(:<<, :add_observer, :remove_observer)
    Workflow = Types.Interface(:states, :services, :messages)
  end

  class Error < StandardError; end

  require_relative "workflows/version"
  require_relative "workflows/name_to_s"
  require_relative "workflows/action"
  require_relative "workflows/state"
  require_relative "workflows/workflow"
  require_relative "workflows/task"
  require_relative "workflows/builder"

  # @return [Plumbing::Pipe] message queue for broadcasting events
  setting :messages, default: Plumbing::Pipe.start, reader: true
  # @return [Hash] a set of services available within this service
  setting :services, default: {}, reader: true
end
