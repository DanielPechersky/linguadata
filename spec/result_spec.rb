# typed: false
# frozen_string_literal: true

RSpec.describe Linguadata::Result do
  it "Result::Success and Result::Failure share the exact same methods" do
    expect(described_class::Success.instance_methods).to match_array(described_class::Failure.instance_methods)
  end

  it "returns value as option" do
    expect(described_class::Success[1].success).to eq(Linguadata::Option::Some[1])
  end
end
