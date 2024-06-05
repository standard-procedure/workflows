# frozen_string_literal: true

require "dry/struct"

module Workflows
  class Action < Dry::Struct
    attribute :name, Types::Strict::String

    def act_on card
    end

    def to_s
      name
    end
  end
end
