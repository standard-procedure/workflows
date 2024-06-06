# frozen_string_literal: true

require "dry/struct"
require_relative "state"

module Workflows
  class Workflow < Dry::Struct
    include NameToS

    attribute :name, Types::Name
    attribute :states, Types::States
  end
end
