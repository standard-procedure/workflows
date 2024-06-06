require "spec_helper"

RSpec.describe Workflows::Card do
  it "tells its current state to perform an action" do
    @initial_state = Workflows::State.new(name: "Initial", actions: {})

    @card = Workflows::Card.new(id: "123", name: "New order", state: @initial_state)
    expect(@initial_state).to receive(:perform_action).with("some_action", card: @card)

    @card.perform("some_action")
  end

  it "emits an event"
end
