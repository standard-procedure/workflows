# frozen_string_literal: true

require "dry/struct"
require_relative "action"

module Workflows
  # The state in a {Workflows::Workflow} state-machine
  class State < Dry::Struct
    include NameToS
    # @return [String]
    attribute :name, Types::String
    # @return [String]
    attribute :type, Types::StateType
    # @return [String]
    attribute :description, Types::String.default("")
    # @return [Integer]
    attribute :default_deadline, Types::Integer.default(7)
    # @return [String]
    attribute :colour, Types::Colour
    # @return [String]
    attribute :assignment_instructions, Types::String.default("")
    # @return [String]
    attribute :completion_by, Types::CompletionBy
    # @return [Array<String>]
    attribute :assign_to, Types::Array.of(Types::String).default([])
    # @return [Array<String>]
    attribute :assign_to_groups, Types::Array.of(Types::String).default([])
    # @return [Array(Workflows::Action)]
    attribute :actions, Types::Actions

    # @param action_name [String] the name of the action to perform
    # @param card [Workflows::Card] the card that will be acted upon
    # @raise [Workflows::State::InvalidAction] if the action_name is invalid
    def perform_action action_name, card:
      card = Types::Card[card]
      action = actions[action_name]
      raise InvalidAction.new(action) if action.nil?

      updater = Types::Operation[Workflows.services["workflows.cards.storage.update.state"]]
      card = updater.call card, state: action.destination

      messages = Types::Messages[Workflows.messages]
      action.outputs.each do |output|
        messages.notify output, card: card
      end
    end

    class InvalidAction < Workflows::Error; end
  end
end
