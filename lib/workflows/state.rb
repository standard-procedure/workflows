# frozen_string_literal: true

require "dry/struct"
require_relative "action"

module Workflows
  class State < Dry::Struct
    include NameToS
    attribute :name, Types::Name
    attribute :actions, Types::Actions

    def perform_action action_name, card:
      card = Types::Card[card]
      action = actions[action_name]
      raise InvalidAction.new(action) if action.nil?
      card = Workflows.cards.update card, state: action.destination
      action.outputs.each do |output|
        card.emit output
      end
    end

    class InvalidAction < Workflows::Error; end
  end
end
