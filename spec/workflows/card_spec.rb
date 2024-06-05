require "spec_helper"

RSpec.describe Workflows::Card do
  context "changing state" do
    it "tells its current state to perform the action" do
      @initial_state = Workflows::State.new(name: "Initial", actions: [])
      @workflow = Workflows::Workflow.new(name: "A Workflow", states: [@initial_state])

      @card = Workflows::Card.new(state: @initial_state)
      expect(@initial_state).to receive(:perform_action).with("some_action", card: @card)

      @card.perform("some_action")
    end
  end
end
