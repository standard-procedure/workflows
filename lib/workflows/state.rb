# frozen_string_literal: true

require "dry/struct"
require_relative "action"

module Workflows
  class State < Dry::Struct
    attribute :name, Types::Strict::String
    attribute :actions, Types::Strict::Array.of(Workflows::Action)

    def perform_action action, card:
      action = find_action_by_name(action)
      raise InvalidAction.new(action) if action.nil?
      puts "FOUND ACTION #{action}"
      action.act_on card
    end

    def to_s
      name
    end

    class InvalidAction < Workflows::Error; end

    private

    def find_action_by_name name
      name = name.to_s.strip
      actions.find { |a| a.name == name }
    end
  end
end
