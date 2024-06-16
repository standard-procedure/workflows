# frozen_string_literal: true

require "dry/struct"
require_relative "state"

module Workflows
  # Workflow represents the structure of a finite state machine that {Workflows::Card}s move through.
  class Workflow < Dry::Struct
    include NameToS

    # @return [String]
    attribute :name, Types::String
    # @return [String]
    attribute :description, Types::String.default("")
    # @return [Array(Workflows::State)]
    attribute :states, Types::States
  end
end
