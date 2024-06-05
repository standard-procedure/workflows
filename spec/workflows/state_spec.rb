require "spec_helper"

RSpec.describe Workflows::State do
  context "changing a card's state" do
    it "raises a Workflows::State::InvalidAction exception if the given action is not valid" do
      @state = Workflows::State.new(name: "Some state", actions: [])
      @card = Workflows::Card.new(state: @state)

      expect { @state.perform_action("some_action", card: @card) }.to raise_exception(Workflows::State::InvalidAction)
    end

    it "tells the action to act on the card" do
      @action = Workflows::Action.new(name: "some_action")
      @state = Workflows::State.new(name: "Some state", actions: [@action])
      @card = Workflows::Card.new(state: @state)

      expect(@action).to receive(:act_on).with(@card)

      @state.perform_action("some_action", card: @card)
    end
  end
end
