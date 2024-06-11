# frozen_string_literal: true

require "dry/struct"
require_relative "state"

module Workflows
  # Workflow represents the structure of a finite state machine that {Workflows::Card}s move through.
  class Workflow < Dry::Struct
    include NameToS

    # @return [String]
    attribute :name, Types::Name
    # @return [Array(Workflows::State)]
    attribute :states, Types::States
  end
end
