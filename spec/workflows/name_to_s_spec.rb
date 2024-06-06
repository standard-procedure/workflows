require "spec_helper"

RSpec.describe Workflows::NameToS do
  it "sets a default `to_s` method on the included object" do
    @class = Class.new do
      include Workflows::NameToS

      def initialize name
        @name = name
      end
      attr_reader :name
    end

    @object = @class.new("Georgia")
    expect(@object.to_s).to eq "Georgia"
  end
end
