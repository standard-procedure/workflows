# frozen_string_literal: true

require "dry/struct"

module Workflows
  class Task < Dry::Struct
    attribute :id, Types::ID
    attribute :name, Types::Name
    attribute :state, Types::State
  end

end
