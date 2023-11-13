# frozen_string_literal: true

RSpec.describe Linguadata::Result do
  let(:success) { described_class::Success }
  let(:failure) { described_class::Failure }

  it "Result::Success and Result::Failure share the exact same methods" do
    expect(success.instance_methods).to match_array(failure.instance_methods)
  end

  it "returns value as option" do
    expect(success[1].success).to eq(Linguadata::Option::Some[1])
  end

  it "map methods work as expected" do
    expect(success[1].map { |x| x + 1 }).to eq(success[2])
    expect(failure[1].map { |x| x + 1 }).to eq(failure[1])
    expect(success[1].map_failure { |x| x + 1 }).to eq(success[1])
    expect(failure[1].map_failure { |x| x + 1 }).to eq(failure[2])
  end
end
