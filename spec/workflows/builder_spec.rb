require "spec_helper"

RSpec.describe Workflows::Builder do
  context "loading a configuration from a text file" do
    it "creates a new workflow with the given states and actions and automations" do
      filename = File.join(__dir__, "./approvals.yml")
      configuration = YAML.load(File.open(filename), symbolize_names: true)
      workflow = Workflows::Builder.new(configuration: configuration).call

      expect(workflow.name).to eq "Approvals"

      verify_requires_review_state_for workflow
      verify_requires_modification_state_for workflow
      verify_approved_state_for workflow
      verify_rejected_state_for workflow
#       verify_rejected_automation_for workflow
#       verify_approved_automation_for workflow
    end

    def verify_requires_review_state_for workflow
      workflow.states[0].tap do |state|
        expect(state.type).to eq "initial"
        expect(state.name).to eq "Requires review"
        expect(state.description).to eq "Documents require review"
        expect(state.colour).to eq "warning"
        expect(state.default_deadline).to eq 3
        expect(state.assign_to).to be_empty
        expect(state.assign_to_groups).to eq ["Document reviewers"]
        expect(state.assignment_instructions).to eq "Please review the attached documents"
        expect(state.completion_by).to eq "anyone"
        expect(state.actions.count).to eq 3

        state.actions[0].tap do |action|
          expect(action.name).to eq "Reject"
          expect(action.colour).to eq "danger"
          expect(action.prompt).to eq "Reason for rejection"
          expect(action.move_to).to eq "Rejected"
          expect(action.automations.count).to eq 1
          expect(action.automations.first).to eq "Move to rejected folder"
        end

        state.actions[1].tap do |action|
          expect(action.name).to eq "Requires modification"
          expect(action.colour).to eq "warning"
          expect(action.prompt).to eq "Changes required"
          expect(action.move_to).to eq "Requires modification"
          expect(action.automations).to be_empty
        end

        state.actions[2].tap do |action|
          expect(action.name).to eq "Approve"
          expect(action.colour).to eq "success"
          expect(action.prompt).to be_nil
          expect(action.move_to).to eq "Approved"
          expect(action.automations.count).to eq 1
          expect(action.automations.first).to eq "Move to approved folder"
        end
      end
    end

    def verify_requires_modification_state_for workflow
      workflow.states[1].tap do |state|
        expect(state.name).to eq "Requires modification"
        expect(state.type).to eq "in_progress"
        expect(state.description).to eq "Documents require modification"
        expect(state.colour).to eq "warning"
        expect(state.default_deadline).to eq 14
        expect(state.assign_to).to eq ["originator"]
        expect(state.assign_to_groups).to be_empty
        expect(state.assignment_instructions).to eq "Please make modifications"
        expect(state.completion_by).to eq "anyone"
        expect(state.actions.count).to eq 1

        state.actions[0].tap do |action|
          expect(action.name).to eq "Resubmit"
          expect(action.colour).to eq "success"
          expect(action.prompt).to eq "Modification details"
          expect(action.move_to).to eq "Requires review"
          expect(action.automations).to be_empty
        end
      end
    end

    def verify_approved_state_for workflow
      workflow.states[2].tap do |state|
        expect(state.name).to eq "Approved"
        expect(state.type).to eq "completed"
        expect(state.colour).to eq "success"
        expect(state.actions).to be_empty
      end
    end

    def verify_rejected_state_for workflow
      workflow.states[3].tap do |state|
        expect(state.name).to eq "Rejected"
        expect(state.type).to eq "completed"
        expect(state.colour).to eq "danger"
        expect(state.actions).to be_empty
      end
    end
  end
end
