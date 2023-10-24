# frozen_string_literal: true

RSpec.describe Linguadata::Result do
  it "Result::Success and Result::Failure share the exact same methods" do
    expect(described_class::Success.instance_methods).to match_array(described_class::Failure.instance_methods)
  end

  it "returns value as option" do
    expect(described_class::Success[1].success).to eq(Linguadata::Option::Some[1])
  end

  it "map methods work as expected" do
    expect(described_class::Success[1].map { |x| x + 1 }).to eq(described_class::Success[2])
    expect(described_class::Failure[1].map { |x| x + 1 }).to eq(described_class::Failure[1])
    expect(described_class::Success[1].map_failure { |x| x + 1 }).to eq(described_class::Success[1])
    expect(described_class::Failure[1].map_failure { |x| x + 1 }).to eq(described_class::Failure[2])
  end
end
