require "spec_helper"

RSpec.describe Workflows::Workflow do
  context "starting a task" do

    WORKFLOW = <<~YML
      name: Approvals
      states:
        - name: Requires review
          type: initial
    YML

    it "creates a new task and sets it to the initial state" do
      @task_creator = double "workflows_tasks_create"
      Workflows.services["workflows.tasks.create"] = @task_creator

      @configuration = {
        name: "Workflow",
        states: [{ name: "Start", type: "initial"}]
      }
      @workflow = Workflows::Builder.new(configuration: @configuration).call

      @task = double "Workflows::Task"
      expect(@task_creator).to receive(:call).with(title: "The title").and_return(@task)

      expect(@workflow.create_task(title: "The title")).to eq @task
    end
  end
end
