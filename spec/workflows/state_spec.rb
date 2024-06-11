require "spec_helper"

RSpec.describe Workflows::State do
  context "performing an action" do
    it "updates the card's state and tells it to emit some outputs" do
      Workflows.services["workflows.cards.storage.update.state"] = ->(card, state:) do
        expect(state).to eq @dispatched
        card
      end
      @dispatched = Workflows::State.new(name: "Dispatched", actions: {})
      @dispatch = Workflows::Action.new(destination: @dispatched, outputs: ["card.dispatched"])
      @initial = Workflows::State.new(name: "Iniital", actions: {dispatch: @dispatch})
      @workflow = Workflows::Workflow.new(name: "Order processing", states: [@initial, @dispatched])
      @pipe = Workflows.messages

      @card = Workflows::Card.new(id: "123", name: "New order", state: @initial)

      expect(@pipe).to receive(:notify).with("card.dispatched", card: @card)

      @initial.perform_action "dispatch", card: @card
    end

    it "raises an InvalidAction exception if the action is not valid" do
      @initial = Workflows::State.new(name: "Iniital", actions: {})

      @card = Workflows::Card.new(id: "123", name: "New order", state: @initial)

      expect { @initial.perform_action "dispatch", card: @card }.to raise_exception(Workflows::State::InvalidAction)
    end
  end
end
