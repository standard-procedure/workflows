require "yaml"
require "dry/struct"

module Workflows
  # Build a workflow from configuration
  class Builder < Dry::Struct
    ActionConfiguration = Types::Hash.schema(
      name: Types::String,
      colour: Types::Colour,
      prompt: Types::String.optional.default(nil),
      move_to: Types::String,
      automations: Types::Array.of(Types::String).default([].freeze)
    )
    StateConfiguration = Types::Hash.schema(
      name: Types::String,
      description: Types::String.default("".freeze),
      colour: Types::Colour,
      type: Types::StateType,
      default_deadline: Types::Integer.default(7),
      assign_to: Types::Array.of(Types::String).default([].freeze),
      assign_to_groups: Types::Array.of(Types::String).default([].freeze),
      assignment_instructions: Types::String.default("".freeze),
      completion_by: Types::CompletionBy,
      actions?: Types::Array.of(ActionConfiguration).default([].freeze),
    )
    AutomationsConfiguration = Types::Hash
    WorkflowConfiguration = Types::Hash.schema(
      name: Types::String,
      description: Types::String.default("".freeze),
      states: Types::Array.of(StateConfiguration),
    )

    # @return [Hash]
    attribute :configuration, WorkflowConfiguration

    def call
      states = configuration[:states]&.map do |state_data|
        actions = state_data[:actions]&.map do |action_data|
          Action.new(action_data.slice(:name, :colour, :prompt, :move_to, :automations))
        end
        State.new(state_data.slice(:name, :description, :colour, :type, :default_deadline, :assign_to, :assign_to_groups, :assignment_instructions, :completion_by).merge(actions: actions))
      end
      Workflow.new(name: configuration[:name], description: configuration[:description], states: states)
    end
  end
end
