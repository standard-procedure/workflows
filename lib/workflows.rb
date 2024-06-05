# frozen_string_literal: true

require "dry/types"

module Workflows
  module Types
    include Dry::Types()
  end

  class Error < StandardError; end

  require_relative "workflows/version"
  require_relative "workflows/workflow"
  require_relative "workflows/state"
  require_relative "workflows/card"
end
