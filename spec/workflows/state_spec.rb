require "spec_helper"

RSpec.describe Workflows::State do
  context "performing an action" do
    it "updates the card's state and tells it to emit some outputs" do
      @dispatched = Workflows::State.new(name: "Dispatched", actions: {})
      @dispatch = Workflows::Action.new(destination: @dispatched, outputs: ["card.dispatched"])
      @initial = Workflows::State.new(name: "Iniital", actions: {dispatch: @dispatch})
      @workflow = Workflows::Workflow.new(name: "Order processing", states: [@initial, @dispatched])

      @card = Workflows::Card.new(id: "123", name: "New order", state: @initial)

      expect(Workflows.cards).to receive(:update).with(@card, state: @dispatched).and_return(@card)
      expect(@card).to receive(:emit).with("card.dispatched")

      @initial.perform_action "dispatch", card: @card
    end
  end

  it "raises an InvalidAction exception if the action is not valid" do
    @initial = Workflows::State.new(name: "Iniital", actions: {})

    @card = Workflows::Card.new(id: "123", name: "New order", state: @initial)

    expect { @initial.perform_action "dispatch", card: @card }.to raise_exception(Workflows::State::InvalidAction)
  end
end
