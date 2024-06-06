# frozen_string_literal: true

require "dry/struct"

module Workflows
  class Card < Dry::Struct
    attribute :id, Types::ID
    attribute :name, Types::Name
    attribute :state, Types::State

    def perform action
      state.perform_action action, card: self
    end
  end

  class InMemoryCards
    def initialize
      @cards = {}
    end

    def create
    end

    def find id
      id = Types::ID[id]
      @cards[id]
    end

    def where conditions
    end

    def update card, state: nil
      state = Types::State[state]
      Card.new(id: card.id, name: card.name, state: state).tap do |card|
        @cards[card.id] = card
      end
    end
  end
end
