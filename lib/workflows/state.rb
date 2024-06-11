# frozen_string_literal: true

require "dry/struct"
require_relative "action"

module Workflows
  # The state in a {Workflows::Workflow} state-machine
  class State < Dry::Struct
    include NameToS
    # @return [String]
    attribute :name, Types::Name
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
