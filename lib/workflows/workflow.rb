# frozen_string_literal: true

require "dry/struct"
require_relative "state"

module Workflows
  class Workflow < Dry::Struct
    attribute :name, Types::Strict::String
    attribute :states, Types::Strict::Array.of(Workflows::State)
    def to_s
      name
    end
  end
end
