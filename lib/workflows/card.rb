# frozen_string_literal: true

require "dry/struct"
require_relative "state"

module Workflows
  class Card < Dry::Struct
    attribute :state, Types.Instance(Workflows::State)
    def perform action
      state.perform_action action, card: self
    end
  end
end
